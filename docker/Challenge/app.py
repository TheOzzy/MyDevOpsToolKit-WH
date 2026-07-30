import os
from flask import Flask, render_template
import redis

app = Flask(__name__)
redis_host = os.getenv('REDIS_HOST', 'redis') 
redis_port = int(os.getenv('REDIS_PORT', 6379))
cache = redis.Redis(redis_host, redis_port, decode_responses=True)


@app.route('/')
def index():
    return render_template('index.html', active_page='home')


@app.route('/count')
def count():
    try:
        current_hits = cache.incr('hits')
    except redis.exceptions.ConnectionError:
        current_hits = "Error: Database Offline"

    return render_template('count.html', count=current_hits, active_page='count')
    

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000,debug=True)
