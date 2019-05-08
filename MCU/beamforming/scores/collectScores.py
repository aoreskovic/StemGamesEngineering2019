import time
import subprocess

while 1:

   outCsv = open("../htdocs/scores.csv","w")

   outCsv.write("Team;Scenario 1;Scenario 2;Scenario 3;Scenario 4;Scenario 5;Total;Last evaluated\n")

   gdrive = "C:/work/gdrive/STEM Games 2019/Results/Beamforming/"
   teams = ["Akvanauti"]

   for team in teams:
      teamCsv = open(gdrive+"score_"+team+".csv","r")
      teamScore = teamCsv.read()
      outCsv.write(teamScore+"\n")
      teamCsv.close()
   outCsv.close()

   p = subprocess.Popen(["pscp", "-i", "gamesKey", "../htdocs/scores.csv", "dbarbaric@engineering.stemgames.hr:/var/www/html/scores.csv"])

   time.sleep(15)