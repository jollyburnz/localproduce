# On server startup, create some projects if the database is empty. Left over from the example to show where server code would go if there were any!
if Meteor.is_server
  Meteor.startup ->
    if Projects.find().count() is 0
      names = ["DEMO PROJECT 1", "DEMO PROJECT 2", "DEMO PROJECT 3"]
      i = 0

      while i < names.length
        Projects.insert
          name: names[i]
          target: 100
          status: "GOOD"
          release: "V0.1.2"
          comment: "Dummy comment test"
          risk: "It all might blow up"
          date_created: Date.now()

        i++

