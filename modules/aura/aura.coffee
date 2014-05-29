if Meteor.isClient

  Session.setDefault 'admin.editMode', false

  Template.auraAdminPanel.helpers {
    history: ->
      History.find({}, {sort: {date: -1}})
    getDate: (date)->
      moment(date).lang('ru').format('DD.MM.YYYY HH:MM')
  }


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
#        path = $(e.target).data('selector-path')
#        if $(path).length > 0
#          $(path).addClass('_focus')
#          Meteor.setTimeout ->
#            if $(e.target).is(':hover')
#              $.scrollTo $(path), 500, {offset: -150}
#          , 500

      'click #history-cont li': (e)->
        target = $(e.target).closest('li').data('id')
        Aura._historyRestore(target)
    }

    Template.aura.events {
      'click .close span': ->
        console.log 'closing'
        Aura.hideAdminModal()

    }



    Template.auraEditor.rendered = ->

      editor.auraEditorHtml = ace.edit("editorHtml")
      editor.auraEditorHtml.setTheme("ace/theme/monokai")
      editor.auraEditorHtml.getSession().setMode("ace/mode/html")
      editor.auraEditorHtml.on 'change', (e)->
#        value = editor.auraEditorHtml.getValue().replace(/\s+/g, ' ')
#        target = $('.editor').find('.html-cont').data('path')
#        console.log target
#        console.log value
#        $(target).html(value)
      $('.html-cont').on 'keyup', ->
        Meteor.setTimeout ->
          value = editor.auraEditorHtml.getValue().replace(/\s+/g, ' ')
          target = $('.editor').find('.html-cont').data('path')
          console.log target
          console.log value
          $(target).html(value)
        , 50

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
        val = $('.editor .html-cont').data('resetData')
        editor.auraEditorHtml.setValue(val)

#      'input .editor .html-cont textarea': (e)->
#        path = $(e.target).data('path')
#        $(path).html($(e.target).val().trim())

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
    data = $(e.target).closest('[contenteditable="true"]').html()
    markup = $.htmlClean(data, {format:true})
    editor.showEditor(markup)
    editor._trackChanges.currentValue = data
    editor.editingItem = data
    $('.editor .html-cont').data('resetData', markup)
    $('.editor .html-cont').data('path', $(e.target).closest('[contenteditable="true"]').getPath())

  'input [contenteditable="true"]': (e)->
    markup = $(e.target).html()
    editor.auraEditorHtml.setValue($.htmlClean(markup, {format:true}))

  'click #admin-login-modal .close': ->
    Aura.hideAdminModal()

  'submit #aura-login-form': (e)->
    e.preventDefault()
    email = $('#aura-login-form').find('#email').val()
    password = $('#aura-login-form').find('#password').val()
    Meteor.loginWithPassword email, password, (err)->
      if err
        Aura.notify 'Ошибочка:('
      else
        Aura.notify 'Добро пожаловать!'
        Aura.hideAdminModal()
    false

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
        changable: true
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

  'change .aura-edit-image input[type="file"]': (e)->
    input = $(e.target)
    file = input.get(0).files[0]
    fr = new FileReader()
    MainCtrl.showLoader()
    fr.onload = ->
      pic = {}
      pic['data'] = fr.result
      pic['name'] = file.name
      pic['size'] = file.size
      pic['type'] = file.type
      currentPic = do ->
        if $(e.target).closest('[data-image]').data('image-target') is 'background'
          path = $(e.target).closest('[data-image]').css('background-image')
          _.last(path.split('/')).replace(')', '')
        else
          path = $(e.target).closest('[data-image]').attr('src')
          _.last path.split('/')
      target = $(e.target).closest('[data-image]').data('image-target') or 'img'
      (new PNotify({
        title: 'Удалить старое изображение?',
        text: 'Желательно удалять, чтобы не перегружать хостинг',
        hide: false,
        confirm: {
          confirm: true
        },
        buttons: {
          closer: false,
          sticker: false
        },
        history: {
          history: false
        }
      })).get().on('pnotify.confirm', ->

        Aura.media.updatePic(e, pic, file, target, currentPic)

      ).on('pnotify.cancel', ->
        Aura.media.uploadPic(e, pic, file, target)
      )

    fr.readAsBinaryString(file)

  'change .auraModal .list-cont .add input[type="file"]': (e)->
    console.log 'triggered change'
    input = $(e.target)
    file = input.get(0).files[0]
    id = $('#albumId').val()
    fr = new FileReader()
    MainCtrl.showLoader()
    Aura.media.resizeAndUpload(id, file)

  'dragover [data-image]': (e)->
    if e.preventDefault then e.preventDefault()
    $(e.target).closest('[data-image]').addClass('_hover')
    return false
  'dragenter [data-image]': (e)->
    if e.preventDefault then e.preventDefault()
    $(e.target).closest('[data-image]').addClass('_hover')
    return false
  'dragleave [data-image]': (e)->
    $(e.target).closest('[data-image]').removeClass('_hover')
    return false
  'drop [data-image]': (e)->
    e.preventDefault()
    e.stopPropagation()
    $(e.target).removeClass('_hover')
    file = e.originalEvent.dataTransfer.files[0]
    fr = new FileReader()
    MainCtrl.showLoader()
    fr.onload = ->
      pic = {}
      pic['data'] = fr.result
      pic['name'] = file.name
      pic['size'] = file.size
      pic['type'] = file.type
      currentPic = do ->
        if $(e.target).closest('[data-image]').data('image-target') is 'background'
          path = $(e.target).closest('[data-image]').css('background-image')
          _.last(path.split('/')).replace(')', '')
        else
          path = $(e.target).closest('[data-image]').attr('src')
          _.last path.split('/')
      target = $(e.target).closest('[data-image]').data('image-target') or 'img'
      (new PNotify({
        title: 'Удалить старое изображение?',
        text: 'Желательно удалять, чтобы не перегружать хостинг',
        hide: false,
        confirm: {
          confirm: true
        },
        buttons: {
          closer: false,
          sticker: false
        },
        history: {
          history: false
        }
      })).get().on('pnotify.confirm', ->

        Aura.media.updatePic(e, pic, file, target, currentPic)

      ).on('pnotify.cancel', ->
        Aura.media.uploadPic(e, pic, file, target)
      )

    fr.readAsBinaryString(file)

  'mouseenter .aura-edit-image': (e)->
    $(e.target).closest('[data-image]').addClass('_hover')

  'mouseleave .aura-edit-image': (e)->
    $(e.target).closest('[data-image]').removeClass('_hover')

  'click .aura-toggle-edit': (e)->
    $(e.currentTarget).toggleClass('_active')
    if $(e.currentTarget).hasClass('_active')
      Session.set 'admin.editMode', true
      $(e.currentTarget).find('p').text('правка')
    else
      Session.set 'admin.editMode', false
      $(e.currentTarget).find('p').text('просмотр')

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
    })

  media: {

    uploadPic: (e, pic, file, target)->

      Meteor.call 'uploadPic', pic, (err, res)->
        if err
          MainCtrl.hideLoader()
          Aura.notify('Произошла ошибка, обратитесь к разработчику!')
        else
          if res
            console.log file.name
            fieldName = $(e.target).closest('[data-image]').data('image')
            document = $(e.target).closest('[data-document]').data('document')
            indexField = $(e.target).closest('[data-document]').data('index-field') or '_id'
            collection = $(e.target).closest('[data-collection]').data('collection')
            query = {}
            newData = {}
            query[indexField] = document
            newData[fieldName] = file.name
            targetId = eColl[collection].findOne(query)._id
            eColl[collection].update targetId, {$set: newData}, {reactive: false}, ->
              if target is 'background'
                $('<img>').attr('src', 'http://d9bm0rz9duwg1.cloudfront.net/' + file.name).load ->
                  MainCtrl.hideLoader()
                  $(e.target).closest('[data-image]').css('background-image', 'url(http://d9bm0rz9duwg1.cloudfront.net/' + file.name + ')')

                  #Fix only for FullPage.js weird behavior
                  $(e.target).closest('[data-image]').width($(window).width())
                  $(e.target).closest('[data-image]').siblings('[data-image]').width($(window).width())
                  #end fix

                  Aura.notify('Изображение обновлено, спасибо!')
              else if target is 'img'
                $('<img>').attr('src', 'http://d9bm0rz9duwg1.cloudfront.net/' + file.name).load ->
                  MainCtrl.hideLoader()
                  $(e.target).closest('[data-image]').attr('src', 'url(http://d9bm0rz9duwg1.cloudfront.net/' + file.name)
          else
            MainCtrl.hideLoader()
            Aura.notify('Произошла ошибка, обратитесь к разработчику!')

    updatePic: (e, pic, file, target, currentPic)->

      Meteor.call 'deletePic', currentPic, (err, res)->

        if err

          Aura.notify 'Изображение не удалено:( Может и к лучшему))'

        else

          if res

            Aura.media.uploadPic(e, pic, file, target)

          else

            Aura.notify 'Изображение не удалено:( Ошибка на стороне сервера'

    resizeAndUpload: (id, file)->

      console.log 'triggered upload with resize'

      pic = {}
      resizedPic = {}

      deferred = $.Deferred()

      resize = ()->
        reader = new FileReader()
        reader.readAsDataURL(file)
        reader.onLoad = (e)->
          $.canvasResize(file, {
            width: 300,
            height: 0,
            crop: false,
            quality: 80,
            callback: (data)->
              deferred.resolve(data)
              console.log {data: data}
          })
        deferred.promise()


      originalFile = ()->
        reader = new FileReader()
        deferred = $.Deferred()
        reader.readAsBinaryString(file)
        reader.onload = (e)->
          ifile = reader.result
          deferred.resolve(ifile)
          console.log {reader: ifile}
        deferred.promise()



      $.when(originalFile(), resize()).done (ifile, resizedFile)=>
        console.log 'resolved'
        pic['fileInfo'] = file
        pic['data'] = ifile
        resizedPic['fileInfo'] = file
        resizedPic['data'] = resizedFile
        console.log pic
        console.log resizedPic
        Meteor.call 'uploadWithThumb', [pic, resizedPic], (err, res)->
          if err

            Aura.notify 'Упс, что-то пошло не так:('

          else

            if res

              console.log res

              Gallery.update id, {$push: {'images': res}}, ->

                Aura.notify 'Изображение ' + res + ' добавлено!'

                MainCtrl.hideLoader()

            else

              Aura.notify 'Что-то пошло не так, обратитесь к разработчику!'

    deletePic: (pic)->

      Meteor.call 'deletePic', pic, (err, res)->

        if err

          Aura.notify 'Изображение не удалено:( Может и к лучшему))'

        else

          if res

            Aura.notify 'Изображение успешно удалено!'

          else

            Aura.notify 'Изображение не удалено:( Ошибка на стороне сервера'

    deletePics: (pics)->

      Meteor.call 'deletePics', pics, (err, res)->

        if err

          Aura.notify 'Изображения не удалены:( Может и к лучшему))'

        else

          if res

            Aura.notify 'Изображения успешно удалено!'

          else

            Aura.notify 'Изображения не удалены:( Ошибка на стороне сервера'

  }


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
        History.insert({
          field: history.field,
          collection: history.collection,
          document: history.document
          indexField: history.indexField
          date: new Date()
          data: history.data
          selectorPath: history.selectorPath
          newData: history.newData
          type: history.type
          user: Meteor.user()
          rolledBack: history.rolledBack
          changable: history.changeable
        })
        console.log 'triggered saveHistory iterate'

      else
        target = History.findOne({_id: history._id})
        target.rolledBack = !buffer.rolledBack
        History.update {_id: history._id}, history


    Aura._historyBuffer = []

  _historyRestore: (id)->

    historyItem = History.findOne({_id: id})

    if historyItem.rolledBack

      restoredBuffer = []

      restoredBuffer.push {
        field: historyItem.field
        document: historyItem.document
        collection: historyItem.collection
        indexField: historyItem.indexField
        data: historyItem.newData
        nested: historyItem.nested
      }
      console.log restoredBuffer
      editor.editorSaveText restoredBuffer, ->
        History.update {_id: id}, {$set: {rolledBack: false}}
        console.log 'history restored'

    else

      changedBuffer = []

      changedBuffer.push {
        field: historyItem.field
        document: historyItem.document
        collection: historyItem.collection
        indexField: historyItem.indexField
        data: historyItem.data
        nested: historyItem.nested
      }
      console.log changedBuffer
      editor.editorSaveText changedBuffer, ->
        History.update {_id: id}, {$set: {rolledBack: true}}
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

    editor.editorSaveText buffer, ->


      Aura._logsWrite(Aura._historyBuffer)

      Aura._saveHistory(Aura._historyBuffer)

      editor._changedBuffer = []

      console.log 'changed'

      Aura.notify('Изменения сохранены!')

    true

  editorSaveText: (changedBuffer, callback)->

    console.log changedBuffer

    user = Meteor.user()

    if Roles.userIsInRole user, ['admin']

      console.log 'triggered saveText'

      _.each changedBuffer, (change)->

        if !change.nested

          console.log 'triggered saveText iterate'

          newData = {}

          query = {}
          query[change.indexField] = change.document

          pageId = eColl[change.collection].findOne(query)._id

          newData[change.field] = change.data

          eColl[change.collection].update pageId, {$set: newData}, ->
            console.log 'saved'

            console.log change.data

          callback()


        else if change.nested.type is 'array'

          console.log 'triggered saveText iterate array'

          newData = {}

          query = {}
          query[change.indexField] = change.document

          updateObj = {}

          updateObj['_id'] = eColl[change.collection].findOne(query)._id

          console.log eColl[change.collection].findOne({'name': change.document})._id

          updateObj[change.nested.field + '.id'] = change.nested.id

          newData[change.nested.field + '.$.' + change.field] = change.data

          eColl[change.collection].update updateObj, {$set: newData}, ->
            console.log 'saved'

          callback()

    else

      Meteor.Error(403, 'Not allowed')


  showEditor: (val)->

    $('.editor').addClass('_opened')
    $('.editor').find('button').removeClass('_active')
    editor.auraEditorHtml.setValue(val)

  hideEditor: ->
    $('.editor').removeClass('_opened')
    $('.editor').find('.html-cont').removeClass('flipInX').addClass('flipOutX')

}


Aura.settings = {
  history: {
    size: 50
  }
}