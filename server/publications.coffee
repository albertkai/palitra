Meteor.publish 'gallery', ->
  Gallery.find()

Meteor.publish 'news', ->
  News.find()