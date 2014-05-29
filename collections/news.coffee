@News = new Meteor.Collection('news')

News.allow {
  insert: (userId)->
    if Roles.userIsInRole userId, ['admin']
      true

  update: (userId)->
    if Roles.userIsInRole userId, ['admin']
      true

  remove: (userId)->
    if Roles.userIsInRole userId, ['admin']
      true
}