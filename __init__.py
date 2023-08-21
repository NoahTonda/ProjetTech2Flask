from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SECRET_KEY'] = 'fdde4796080527e318fb949de5d03bcf'
# supprime les notifications inutiles
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
# emplacement de la base de données :
app.config["SQLALCHEMY_DATABASE_URI"] = 'postgresql://anonyme:anonyme@localhost/Projet2'
# format alternatif (copié) :
# app.config["SQLALCHEMY_DATABASE_URI"] ='jdbc:postgresql://localhost:5432/Projet2'
db = SQLAlchemy(app)

from . import routes
