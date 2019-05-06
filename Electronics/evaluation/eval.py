from bs4 import BeautifulSoup
import re
import urllib.request

template = "http://search.digikey.com/scripts/DkSearch/dksus.dll?Detail&name=%s"

def create_component(id):
	url = template % id;
	page = urllib.request.urlopen(url)
	soup = BeautifulSoup(page.read(), features='html.parser')
	return soup

def get_string_price(component):
	pattern = re.compile(r'\s*%s\s*' % "1")
	return component.find('td', text=pattern).find_next("td").text.strip()

def get_string_value(key, component):
	pattern = re.compile(r'\s*%s\s*' % key)
	return component.find('th', text=pattern).find_next("td").text.strip()