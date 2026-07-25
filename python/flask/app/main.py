from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def read_root():
    return jsonify({"Hello": "World"})


@app.get("/health")
def health():
    return jsonify({"status": "ok"})
