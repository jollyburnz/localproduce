# A very simple meteor app built out from the leaderboard example

# link each template value to a db query - meteor propagates any changes to the underlying data in real time, automatically
# (note. this could perhaps be improved by reducing the number of queries and not having so many separate statements?)
Template.statusboard.projects = ->
  Projects.find {},
    sort:
      date_created: 1
      target: -1
      status: 1
      name: 1


Template.statusboard.selected_name = ->
  project = Projects.findOne(Session.get("selected_project"))
  project and project.name

Template.statusboard.selected_status = ->
  project = Projects.findOne(Session.get("selected_project"))
  project and project.status

Template.statusboard.selected_release = ->
  project = Projects.findOne(Session.get("selected_project"))
  project and project.release

Template.statusboard.selected_target = ->
  project = Projects.findOne(Session.get("selected_project"))
  project and project.target

Template.statusboard.selected_comment = ->
  project = Projects.findOne(Session.get("selected_project"))
  project and project.comment

Template.statusboard.selected_risk = ->
  project = Projects.findOne(Session.get("selected_project"))
  project and project.risk

Template.statusboard.selected_risk_level = ->
  project = Projects.findOne(Session.get("selected_project"))
  project and project.risk_level

Template.statusboard.isLoggedIn = ->
  Meteor.userId()?

Template.project.selected = ->
  (if Session.equals("selected_project", @_id) then "selected" else "")

Template.project.isLoggedIn = ->
  Meteor.userId()?

Template.statusboard.events =

  # update project
  "click a.update": ->
    Projects.update Session.get("selected_project"),
      $set:
        name: $("#project_name_edit").val()
        release: $("#project_release_edit").val()
        target: parseInt($("#project_target_edit").val(), 10)
        comment: $("#project_comment_edit").val()
        risk: $("#project_risk_edit").val()
        risk_level: $("#project_risk_level_edit").val()
        status: $("#project_status_edit").val()
        #date_created: Date.now()

    Session.set "selected_project", null


  # remove project
  "click a.remove": ->
    project = Projects.findOne(Session.get("selected_project"))
    Projects.remove _id: project._id  if confirm("Delete " + project.name + "?")


  # insert a new project
  "click a.add": ->
    newName = $("#project_name").val()
    if Validation.valid_name(newName)
      Projects.insert
        name: newName
        target: 0
        status: "IN PROGRESS"
        risk_level: "SAFE"
        date_created: Date.now()

      project = Projects.findOne(name: newName)
      Session.set "selected_project", project._id


  # nothing is selected
  "click a.cancel": ->
    Session.set "selected_project", null


# on clicking a project, update the var which stores this
Template.project.events = click: ->
  console.log 'click', @, Session
  Session.set "selected_project", @_id


# set the selected option for the status drop down
selectedStatus = Template.statusboard.selected_status
Handlebars.registerHelper "isStatusSelected", (selectedStatus, optionValue) ->
  (if selectedStatus is optionValue then " selected" else "")


# choose a colour for the status text
Handlebars.registerHelper "getStatusColor", (selectedStatus) ->
  switch selectedStatus
    when "GOOD"
      return "#9ACD32"
    when "BAD"
      return "orange"
    when "UGLY"
      return "#EE6363"
    when "IN PROGRESS"
      return "#7D9EC0"


# choose a colour for the risk text
Handlebars.registerHelper "getRiskColor", (selectedRisk) ->
  switch selectedRisk
    when "SAFE"
      return "#9ACD32"
    when "DODGY"
      return "orange"
    when "DANGEROUS"
      return "#EE6363"


# set the selected option for the target drop down
selectedTarget = Template.statusboard.selected_target
Handlebars.registerHelper "isTargetSelected", (selectedTarget, optionValue) ->
  (if selectedTarget is optionValue then " selected" else "")


# set the selected option for the risk drop down
selectedRisk = Template.statusboard.selected_risk_level
Handlebars.registerHelper "isRiskSelected", (selectedRisk, optionValue) ->
  (if selectedRisk is optionValue then " selected" else "")

Validation =
  clear: ->
    Session.set "error", `undefined`

  set_error: (message) ->
    Session.set "error", message

  valid_name: (name) ->
    @clear()
    if name.length is 0
      @set_error "Name can't be blank"
      false
    else if @project_exists(name)
      @set_error "Project already exists"
      false
    else
      true

  project_exists: (name) ->
    Projects.findOne name: name
