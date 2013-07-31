root = exports ? this

root.Projects = new Meteor.Collection("projects")

Projects.allow
  insert: ->
    true
  update: ->
    true
  remove: ->
    true