# -*- coding: utf-8 -*-

import time
import subprocess
import io

while 1:

   outCsv = io.open("../htdocs/scores.csv", mode="w", encoding="utf-8")

   outCsv.write("Team;Scenario 1;Scenario 2;Scenario 3;Scenario 4;Scenario 5;Total;Last evaluated\n")

   gdrive = "C:/work/gdrive/STEM Games 2019/Results/Beamforming/"
   teams = ["Akvanauti","Božje ovčice","Divljač velikog momenta tromosti","FERIT","FESB","Gemischt","Kornjače","Mamlazi","Mehrob","Narodne mošnje","Njemački strikani","Papkovi papci","Pero Tips","STEM Gains","Stroicizam","Šiljo i Družina","Škrgići","Team Pokemon","Torpedo"]

   for team in teams:
      teamCsv = io.open(gdrive+"score_"+team+".csv", mode="r", encoding="utf-8")
      teamScore = teamCsv.read()+"\n"
      outCsv.write(teamScore)
      teamCsv.close()
   outCsv.close()

   p = subprocess.Popen(["pscp", "-i", "gamesKey", "../htdocs/scores.csv", "dbarbaric@engineering.stemgames.hr:/var/www/html/scores.csv"])

   time.sleep(15)