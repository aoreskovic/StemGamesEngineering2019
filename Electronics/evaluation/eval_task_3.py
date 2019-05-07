import math

def main(team, path):
	file = open(path)
	lines = file.readlines()

	probability = float(lines[0])

	l1 = 1e-6
	l2 = 2e-6
	t = 10000

	R = (1.0 / (l1 - l2)) * (l1 * math.exp(-l2 * t) - l2 * math.exp(-l1 * t))

	correct = 1 - R

	print(correct)

	pts = 0

	if (probability <= correct + 0.0001 and probability >= correct - 0.0001):
		pts += 5 

	print("%s, %d" % (
		team,
		pts))

if __name__ == "__main__":
	main("TestTeam", "task3.txt")