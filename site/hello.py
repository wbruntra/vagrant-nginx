from flask import (Flask, render_template, Response)
import requests
import json

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello World Two!'

@app.route('/main')
def index():
    return render_template('index.html')

@app.route('/weather')
def report():
    url = "https://bc-fresume.appspot.com/jsonreport"
    r = requests.get(url)
    data = r.content
    res = Response(response = data,
            status = 200,
            mimetype="application/json")
    return res


if __name__ == '__main__':
    app.run()
