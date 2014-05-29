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

      origImage =  {
        Key: pic.name
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
          console.log 'object ' + pic.name + ' uploaded to S3'
          f.return(true)

      f.wait()

    uploadWithThumb: (pics)->

      s3 = new AWS.S3()

      dataUriToBuffer = Meteor.require('data-uri-to-buffer')

      origBuffer = new Buffer(pics[0].data, 'binary')

#      resizedBuffer = dataUriToBuffer(pics[1].data)

      resizedBuffer = new Buffer(pics[1].data, 'binary')

      origImage =  {
        Key: pics[0].fileInfo.name
        ContentType: pics[0].fileInfo.type
        Body: origBuffer
        Bucket: 'palitra'
      }

      resizedImgName = do ->
        str = ''
        split = pics[0].fileInfo.name.split('.')
        str = split[0] + '_thumb.' + split[1]
        str

      resizedImage =  {
        Key: resizedImgName
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
          console.log 'object ' + pics[0].fileInfo.name + ' uploaded to S3'
          f.return(true)

      f.wait()

      f = new Future()

      s3.putObject resizedImage, (err, data)->
        if err
          console.log err
          f.return(false)
        else
          console.log 'object ' + pics[1].fileInfo.name + '_thumb uploaded to S3'
          f.return(true)

      f.wait()

      pics[0].fileInfo.name

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

  }