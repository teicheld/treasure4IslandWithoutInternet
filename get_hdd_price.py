#!/usr/bin/python3

from selenium import webdriver
from selenium.webdriver.firefox.options import Options as FirefoxOptions

options = FirefoxOptions()
options.add_argument("--headless")
driver = webdriver.Firefox(options=options)
driver.get("https://www.amazon.de/Western-Digital-Blue-Festplatte-WD40EZAZ/dp/B087QTVCHH/")
price=driver.find_element_by_id("priceblock_ourprice").text
print(price)

