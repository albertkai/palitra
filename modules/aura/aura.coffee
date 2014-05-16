if Meteor.isClient

  Session.setDefault 'admin.editMode', false


  Meteor.startup ->


    Deps.autorun ->
      if Session.get('admin.editMode') is true
        $('[contenteditable]').each ->
          $(this).attr('contenteditable', 'true')
      else
        $('[contenteditable]').each ->
          $(this).attr('contenteditable', 'false')

    Mousetrap.bind 'q w e', (e)->
      Aura.showAdminModal()

    Mousetrap.bind 'й ц у', (e)->
      Aura.showAdminModal()

    Template.auraAdminPanel.events {
      'click #edit-mode': (e)->
        if $(e.target).is(':checked')
          Session.set('admin.editMode', true)
        else
          Session.set('admin.editMode', false)

      'mouseenter #history-cont li': (e)->
        path = $(e.target).data('selector-path')
        if $(path).length > 0
          $(path).addClass('_focus')
          Meteor.setTimeout ->
            if $(e.target).is(':hover')
              $.scrollTo $(path), 500, {offset: -150}
          , 500

      'click #history-cont li': (e)->
        target = $(e.target).closest('li').data('id')
        Aura._historyRestore(target)
    }

    Template.auraAdminPanel.helpers {
      history: ->
        History.find({}, {sort: {date: -1}})
      getDate: (date)->
        moment(date).lang('ru').format('DD.MM.YYYY HH:MM')
    }

    Template.aura.events {
      'click .close span': ->
        console.log 'closing'
        Aura.hideAdminModal()

    }



    Template.auraEditor.events {

      'click button': (e)->
        $(e.target).closest('button').toggleClass('_active')

      'click #b-html': (e)->
        if $(e.target).hasClass('_active')
          $('.editor .html-cont').css('visibility', 'visible').removeClass('flipOutX').addClass('animated flipInX')
          console.log 'this ' + editor._editingItem
        else
          $('.editor .html-cont').removeClass('flipInX').addClass('flipOutX')

      'click .editor .html-cont button': (e)->
        target = $(e.target).siblings('textarea')
        target.val(target.data('resetData'))
        console.log target.data('resetData')
        $(target.data('path')).html(target.val())

      'input .editor .html-cont textarea': (e)->
        path = $(e.target).data('path')
        $(path).html($(e.target).val().trim())

      'blur .editor .html-cont textarea': (e)->
    #    index = $(e.target).data('index')
    #    html = $(e.target).val()
    #    console.log index
    #    console.log Aura._historyBuffer[index].newData
    #    Aura._historyBuffer[index].newData = html
    #    editor._changedBuffer[index].data = html
        $($(e.target).data('path')).trigger('blur')



      'click #b-bold': ->
        editor.commands.bold()

      'click #b-italic': ->
        editor.commands.italic()

      'click #b-sub': ->
        editor.commands.sub()

      'click #b-sup': ->
        editor.commands.sup()

      'click #b-ul': ->
        editor.commands.ul()

      'click #b-ol': ->
        editor.commands.ol()

      'click #b-h1': ->
        editor.commands.h1()

      'click #b-h2': ->
        editor.commands.h2()

      'click #b-h3': ->
        editor.commands.h3()

      'click #b-h4': ->
        editor.commands.h4()

      'click #b-h5': ->
        editor.commands.h5()

      'click #b-h6': ->
        editor.commands.h6()

      'click #b-span': ->
        editor.commands.span()

      'click #b-link': ->
        editor.commands.link()

      'click #b-save': (e)->


        editor.hideEditor()
        editor.save()

    }



UI.body.events {

  'mouseover [contenteditable="true"]': (e)->
    target = $(e.target).closest('[contenteditable="true"]')
    target.addClass('_editor-hover')
    Meteor.setTimeout ->
      target.removeClass('_editor-hover')
    , 600

  'click [contenteditable="true"]': (e)->
    e.stopPropagation()

  'focus [contenteditable="true"]': (e)->
    editor.showEditor()
    editor._trackChanges.currentValue = $(e.target).closest('[contenteditable="true"]').html()
    editor.editingItem = $(e.target).closest('[contenteditable="true"]').html()
    $('.editor .html-cont textarea').val(editor.editingItem.trim())
    $('.editor .html-cont textarea').data('resetData', editor.editingItem.trim())
    $('.editor .html-cont textarea').data('path', $(e.target).closest('[contenteditable="true"]').getPath())

  'input [contenteditable="true"]': (e)->
    markup = $(e.target).html()
    $('.editor .html-cont textarea').val(markup.trim())

  'click #login-buttons-logout, click #login-buttons-password': ->
    Aura.hideAdminModal()

  'blur [contenteditable="true"]': (e)->
    currentState = $(e.target).closest('[contenteditable="true"]').html()
    if currentState isnt editor.editingItem
      fieldData = $(e.target).data('field')
      $('.editor .html-cont textarea').data('index', Aura._historyBuffer.length)
      fields = do ->
        if fieldData.match /^\$/
          id = $(e.target).closest('[data-nested-id]').data('nested-id')
          {
          field: fieldData.split('.')[2]
          nested: {
            id: id
            type: 'array'
            field: fieldData.split('.')[1]
          }
          }
        else if fieldData.match /\./
          {
          field: fieldData.split('.')[1]
          nested: {
            type: 'prop'
            field: fieldData.split('.')[0]
          }
          }
        else
          {
          field: fieldData
          nested: null
          }

      indexField = do ->
        if $(e.target).closest('[data-document]').data('index-field')
          $(e.target).closest('[data-document]').data('index-field')
        else
          '_id'

      Aura._historyBuffer.push {
        field: $(e.target).data('field')
        document: $(e.target).closest('[data-document]').data('document')
        indexField: indexField
        collection: $(e.target).closest('[data-collection]').data('collection')
        data: editor.editingItem
        newData: $(e.target).closest('[contenteditable="true"]').html()
        selectorPath: $(e.target).getPath()
        type: 'text'
        rolledBack: false
        nested: fields.nested
      }
      editor._changedBuffer.push {
        field: fields.field
        document: $(e.target).closest('[data-document]').data('document')
        collection: $(e.target).closest('[data-collection]').data('collection')
        indexField: indexField
        data: $(e.target).closest('[contenteditable="true"]').html()
        nested: fields.nested
      }
      console.log editor._changedBuffer
      $(e.target).closest('[contenteditable="true"]').addClass('_changed')
}




@Aura = {

  showAdminModal: ->
    $('#admin-login-modal').css('visibility', 'visible').removeClass('flipOutY').addClass('animated flipInY')

  hideAdminModal: ->
    $('#admin-login-modal').removeClass('flipInY').addClass('flipOutY')
    setTimeout ->
      $('#admin-login-modal').css('visibility', 'hidden')
    , 500

  notify: (message)->
    new PNotify({
      title: 'Спасибо!',
      text: message
    });




  _logsWrite: (buffer)->

    _.each buffer, (log)->
      Logs.insert {
        field: log.field,
        collection: log.collection,
        date: new Date()
        user: 'Albert Kai'
      }

  _historyBuffer: []

  _saveHistory: (buffer)->

    console.log 'triggered saveHistory'

    historyCount = History.find().count()
    if historyCount + buffer.length > Aura.settings.history.size
      toDeleteSize = historyCount + buffer.length - Aura.settings.history.size
      toDelete = History.find({}, {sort: {date : 1}, limit: toDeleteSize }).fetch()
      toDelete.forEach (item)->
        id = item._id
        History.remove id


    _.each buffer, (history)->
      if !history.rolledBack
        History.insert {
          field: history.field,
          collection: history.collection,
          document: history.document
          date: new Date()
          data: history.data
          selectorPath: history.selectorPath
          newData: history.newData
          type: history.type
          user: Meteor.user()
          rolledBack: history.rolledBack
        }
        console.log 'triggered saveHistory iterate'

      else
        target = History.findOne({_id: history._id})
        target.rolledBack = !buffer.rolledBack
        History.update {_id: history._id}, history


    Aura._historyBuffer = []

  _historyRestore: (id)->

    buffer = History.findOne({_id: id})

    if buffer.rolledBack
      buffer.data = buffer.newData

    #    editor._changedBuffer.push {
    #      field: buffer.field
    #      document: buffer.document
    #      collection: buffer.collection
    #      data: restoredData
    #      nested: buffer.nested
    #    }

    History.update {_id: id}, {$set: {rolledBack: !buffer.rolledBack}}

    editor._saveText [buffer], ->
      #      History.remove {_id: id}
      console.log 'history restored'

}


@editor = {

  _editingItem: ''

  _changedBuffer: []

  commands: {

    bold: ()->

      document.execCommand('bold', null, null)

    italic: ->

      document.execCommand('italic', null, null)

    sub: ->

      document.execCommand('subscript', null, null)

    sup: ->

      document.execCommand('superscript', null, null)

    ul: ->

      document.execCommand('insertUnorderedList', null, null)

    ol: ->

      document.execCommand('insertOrderedList', null, null)

    h1: ->

      document.execCommand('formatBlock', null, '<h1>')

    h2: ->

      document.execCommand('formatBlock', null, '<h2>')

    h3: ->

      document.execCommand('formatBlock', null, '<h3>')


    h4: ->

      document.execCommand('formatBlock', null, '<h4>')


    h5: ->

      document.execCommand('formatBlock', null, '<h5>')


    h6: ->

      document.execCommand('formatBlock', null, '<h6>')


    span: ->

      document.execCommand('formatBlock', null, '<span>')

    link: ->

      document.execCommand('createLink', false, prompt('Введите URL'))
  }



  save: ->

    if @_changedBuffer.length > 0
      @_saveText(@_changedBuffer)

  _trackChanges:

    currentValue: ''

    check: ($el)->

      console.log @currentValue

      if $el.html() isnt @currentValue

        true

      else

        false


  _saveText: (buffer)->

    Meteor.call 'editorSaveText', buffer, ->


      Aura._logsWrite(Aura._historyBuffer)

      Aura._saveHistory(Aura._historyBuffer)

      editor._changedBuffer = []

      console.log 'changed'

      Aura.notify('Изменения сохранены!')

    true


  showEditor: ->

    $('.editor').addClass('_opened')
    $('.editor').find('button').removeClass('_active')

  hideEditor: ->
    $('.editor').removeClass('_opened')
    $('.editor').find('.html-cont').removeClass('flipInX').addClass('flipOutX')

}


Aura.settings = {
  history: {
    size: 20
  }
}