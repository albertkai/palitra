if Meteor.isServer
  Meteor.startup ->
    @Future = Npm.require('fibers/future')
    @fs = Npm.require('fs')
    process.env.MAIL_URL = 'smtp://postmaster@sandbox32926.mailgun.org:5ty-i8q8jz-3@smtp.mailgun.org:587'
    AWS.config.update
      accessKeyId: 'AKIAJKHELBJSF7V6D7FQ'
      secretAccessKey: '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'
