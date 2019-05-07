from eval import *
import math

def tests_inductor(inductor):
	# check rated current
	pts = 0
	I_c = float(get_string_value("Current Rating", inductor)[:-1])
	if (I_c >= 1.0):
		pts += 1
	return pts

def tests_capacitor(capacitor):
	# check rated voltage
	pts = 0
	V_c = float(get_string_value("Voltage - Rated", capacitor)[:-1])
	if (V_c >= 1.5 * 10.00):
		pts += 0.5

	if get_string_value("Package / Case", capacitor).startswith("0805"):
		pts += 0.5

	return pts

def tests_rejection(inductor, capacitor):
	# check rejection 
	pts = 0

	capacitance = float(get_string_value("Capacitance", capacitor)[:-2])
	inductance = float(get_string_value("Inductance", inductor)[:-2])

	w0 = 1 / math.sqrt(capacitance * inductance)
	w = 12.8e3

	Q = capacitance * 1e-6 * w0 * 10;

	H = w0**2 / math.sqrt((w0**2 - w**2)**2 + w0**2 * w**2 / Q**2) 
	rejection = -20 * math.log10(H)

	if (rejection >= 20):
		pts += 1

	return pts


def tests_Q_factor(inductor, capacitor):
	# check quality factor 
	pts = 0

	capacitance = float(get_string_value("Capacitance", capacitor)[:-2])
	inductance = float(get_string_value("Inductance", inductor)[:-2])

	w0 = 1 / math.sqrt(capacitance * 1e-6 * inductance * 1e-6)

	Q_factor = capacitance * 1e-6 * w0 * 10

	if (Q_factor <= 1.0 and Q_factor >= 0.5):
		pts += 1

	print("C = %s, Q = %s" % (capacitance, Q_factor))

	return pts

def tests_price(inductor, capacitor):
	# get price
	return float(get_string_price(inductor)) + \
		float(get_string_price(capacitor))

def main(team, path):
	file = open(path)
	lines = file.readlines()

	inductor = create_component(lines[0])
	capacitor = create_component(lines[1])

	print("%s, %d, %d, %d, %d, %f" % (
		team,
		tests_inductor(inductor), 
		tests_capacitor(capacitor),
		tests_rejection(inductor, capacitor), 
		tests_Q_factor(inductor, capacitor), 
		tests_price(inductor, capacitor)))

if __name__ == "__main__":
	main("TestTeam", "task2.txt")