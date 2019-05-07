from eval import *

def get_zener_voltage(diode):
	return float(get_string_value("Voltage - Zener", diode)[:-1])

def tests_resistor(resistor):
	# check resistor footprint
	pts = 0;
	if get_string_value("Package / Case", resistor).startswith("0805"):
		pts += 1

	return pts

def tests_output(diode):
	# check output voltage
	pts = 0
	Vz = get_zener_voltage(diode)
	Vout = Vz * (1 + 1 / 0.47)
	if (abs(Vout - 10.00) <= 0.5):
		pts += 1

	return pts

def tests_diode(diode):
	# check diode mounting type
	pts = 0;
	if get_string_value("Mounting", diode).startswith("Through"):
		pts += 1

	return pts

def tests_regulation(resistor, diode):
	pts = 0

	# calculate current
	Vz = get_zener_voltage(diode)
	Rs = float(get_string_value("Resistance", resistor).split()[0])

	I = (12.00 - Vz) / Rs;

	P_diode = Vz * I;
	P_resistor = I * I * Rs;

	#print(P_diode)
	#print(P_resistor)
	
	# check power ratings
	P_max_diode = float(get_string_value("Power", diode)[:-2])
	P_max_resistor = float(get_string_value("Power", resistor).split(',')[0][:-1])

	#print(P_max_resistor)

	if (P_diode <= P_max_diode and P_resistor <= P_max_resistor):
		pts += 1


	return pts

def tests_price(resistor, diode):
	# get price
	return float(get_string_price(resistor)) + float(get_string_price(diode))

def main(team, path):
	file = open(path)
	lines = file.readlines()

	resistor = create_component(lines[0])
	diode = create_component(lines[1])

	print("%s, %d, %d, %d, %d, %f" % (
		team,
		tests_resistor(resistor), 
		tests_diode(diode),
		tests_regulation(resistor, diode), 
		tests_output(diode), 
		tests_price(resistor, diode)))

if __name__ == "__main__":
	main("TestTeam", "task1.txt")