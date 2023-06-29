from flask import Flask, request, session
from flask_cors import CORS
from models import db, Data
from flask_migrate import Migrate

app = Flask(__name__)
CORS(app)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///app.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.json.compact = False

migrate = Migrate(app, db)

db.init_app(app)

@app.route("/")
def home():
    return "<p>Hello world!</p>"

@app.get("/data")
def get_data():
    try:
        return [datum.to_dict() for datum in Data.query.all()], 200
    except:
        return {"error": "Data not found"}, 404

@app.get("/data/<int:id>")
def get_datum(id):
    try:
        data = Data.query.get(id)
        return data.to_dict(), 200
    except:
        return {"error": "Data not found"}, 404
    
@app.post("/data")
def create_datum():
    try:
        new_datum = Data(**request.json)
        db.session.add(new_datum)
        db.session.commit()
        return new_datum.to_dict(), 201
    except:
        return {"error": "Invalid input"}, 400

if __name__ == '__main__':
    app.run(port=5555, debug=True)