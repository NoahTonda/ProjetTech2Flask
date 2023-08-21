from . import app, db
from flask_sqlalchemy import SQLAlchemy
from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField, FileField, SelectField, TextAreaField, DecimalField
from wtforms.validators import DataRequired


class vue_pizzas_categories(db.Model):
    id_pizza = db.Column(db.Integer, primary_key=True)
    nom_pizza = db.Column(db.String(25), nullable=False)
    prix = db.Column(db.Float, nullable=True)
    id_cat = db.Column(db.Integer)
    nom_cat = db.Column(db.String(25), nullable=False)


def __repr__(self):
    return f'{self.id_pizza} : {self.nom_pizza}  : {self.prix_pizza} : {self.nom_cat}'


class categorie(db.Model):
    id_cat = db.Column(db.Integer, primary_key=True)
    nom_cat = db.Column(db.String(30), nullable=False)

    def __repr__(self):
        return f'{self.id_categorie} : {self.nom_categorie} '


class pizza(db.Model):
    id_pizza = db.Column(db.Integer, primary_key=True)
    nom_pizza = db.Column(db.String(25), nullable=False)
    prix = db.Column(db.Float(10), nullable=True)
    id_cat = db.Column(db.Integer)

    def __repr__(self):
        return f'{self.id_pizza} : {self.nom_pizza} : {self.prix} : {self.id_cat}'


class pizzaForm(FlaskForm):
    id_pizza = StringField('ID de la pizza')
    nom_pizza = StringField('Nom de la pizza', validators=[DataRequired()])
    prix = DecimalField('Prix de la pizza', validators=[DataRequired()])
    id_cat = SelectField('Catégorie de la pizza', choices=[(1, 'Cat 1'), (2, 'Cat 2'), (3, 'Cat 3')])
    submit = SubmitField('Ajouter')
