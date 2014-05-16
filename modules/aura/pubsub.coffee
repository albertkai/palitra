if Meteor.isServer

  Meteor.publish 'pages', ->
    Pages.find()


if Meteor.isClient

  Meteor.subscribe 'pages', ->
    Session.set('pagesReady', true)


if Meteor.isServer

  Meteor.methods {
    editorSaveText: (changedBuffer)->

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

      else

        Meteor.Error(403, 'Not allowed')
  }