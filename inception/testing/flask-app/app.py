from flask import Flask, jsonify
import redis

app = Flask(__name__)

# Connect to Redis (default localhost:6379)
r = redis.Redis(host="redis", port=6379, db=0)

@app.route("/")
def home():
    return "Welcome to my Flask app with Redis!"

@app.route("/counter")
def counter():
    # Increment a counter key in Redis
    count = r.incr("mycounter")
    return jsonify(counter=count)

@app.route("/reset")
def reset():
    r.set("mycounter", 0)
    return jsonify(message="Counter reset to 0")

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
