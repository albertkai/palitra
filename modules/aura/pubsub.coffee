if Meteor.isServer

  Meteor.publish 'pages', ->
    Pages.find()

  Meteor.publish 'history', ->
    History.find()

  Meteor.publish 'logs', ->
    History.find()

if Meteor.isClient

  Session.set('pagesReady', false)

  Meteor.subscribe 'pages', ->
    Session.set('pagesReady', true)

  Meteor.subscribe 'history'

  Meteor.subscribe 'logs'


if Meteor.isServer

  Meteor.methods {

    uploadPic: (pic)->

      s3 = new AWS.S3()

      buffer = new Buffer(pic.data, 'binary')

      newName = do ->
        extention = _.last pic.name.split('.')
        randomName = Random.id()
        randomName + '.' + extention

      origImage =  {
        Key: newName
        ContentType: pic.type
        Body: buffer
        Bucket: 'palitra'
      }

      f = new Future()

      s3.putObject origImage, (err, data)->
        if err
          console.log err
          f.return(false)
        else
          console.log 'object ' + pic.name + ' with new name ' + newName + ' uploaded to S3! Congrats!'
          f.return(true)

      f.wait()

    uploadWithThumb: (pics)->

      s3 = new AWS.S3()

      origBuffer = new Buffer(pics[0].data, 'binary')

      resizedBuffer = new Buffer(pics[1].data, 'binary')

      newName = do ->
        extention = _.last pics[0].fileInfo.name.split('.')
        randomName = Random.id()
        {
          orig: randomName + '.' + extention
          thumb: randomName + '_thumb.' + extention
        }


      origImage =  {
        Key: newName.orig
        ContentType: pics[0].fileInfo.type
        Body: origBuffer
        Bucket: 'palitra'
      }

      resizedImage =  {
        Key: newName.thumb
        ContentType: pics[0].fileInfo.type
        Body: resizedBuffer
        Bucket: 'palitra'
      }

      f = new Future()

      s3.putObject origImage, (err, data)->
        if err
          console.log err
          f.return(false)
        else
          console.log 'object ' + pics[0].fileInfo.name + 'named ' + newName.orig + ' uploaded to S3! Congrats!'
          f.return(true)

      f.wait()

      f = new Future()

      s3.putObject resizedImage, (err, data)->
        if err
          console.log err
          f.return(false)
        else
          console.log 'object ' + pics[1].fileInfo.name + ' thumb named' + newName.thumb + 'uploaded to S3'
          f.return(true)

      f.wait()

      newName.orig

    deletePic: (pic)->

      s3 = new AWS.S3()

      params = {
        Bucket: 'palitra'
        Key: pic
      }

      f = new Future()

      s3.deleteObject params, (err, data)->
        if (err)
          console.log(err, err.stack)
          f.return(false)
        else
          console.log('object ' + pic + ' deleted from S3')
          f.return(true)

      f.wait()


    deletePics: (pics)->

      if pics.length > 0

        s3 = new AWS.S3()

        params = {
          Bucket: 'palitra',
          Delete: {
            Objects: []
          }
        }

        pics.forEach (pic)->
          obj = {}
          obj['Key'] = pic
          params.Delete.Objects.push obj

        f = new Future()

        s3.deleteObjects params, (err, data)->
          if (err)
            console.log(err, err.stack)
            f.return(false)
          else
            console.log('object ' + pics + ' deleted from S3')
            f.return(true)

        f.wait()

      else

        console.log 'no pics to delete'

        true

  }