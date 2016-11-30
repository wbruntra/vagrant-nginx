from flask import (Flask, render_template, redirect,
                    url_for, request, make_response)
import json
import pymysql

app = Flask(__name__)

def query_db(name):
    conn = pymysql.connect(host='localhost', port=3306, user='root', passwd='test123', db='treehouse_movie_db')

    cur = conn.cursor(pymysql.cursors.DictCursor)

    cur.execute("SELECT * FROM movies WHERE year = %s" % (name))

    result = cur.fetchall()

    cur.close()
    conn.close()
    return result

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/search', methods=['POST'])
def search():
    form = dict(request.form.items())
    name = form['name']
    results = query_db(name)
    return render_template('results.html', results=results)

if __name__ == '__main__':
    app.run()
