import time

while 1:

   outCsv = open("scores.csv","w")

   outCsv.write("Team;Scenario 1;Scenario 2;Scenario 3;Scenario 4;Total;Last evaluated\n")

   teams = ["reference"]

   for team in teams:
      teamCsv = open("score_"+team+".csv","r")
      teamScore = teamCsv.read()
      outCsv.write(teamScore+"\n")
      teamCsv.close()

   outCsv.close()

   time.sleep(1)