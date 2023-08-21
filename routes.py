from flask import render_template, url_for, request, redirect
from . import app, models, db
from .models import pizzaForm


@app.route('/')
@app.route("/accueil")  # deux URL valables pour l'ouverture de la page accueil.html
def accueil():
    liste_categories = models.vue_pizzas_categories.query.distinct('nom_cat')
    return render_template('accueil.html',
                           title='Bienvenue dans notre boutique',
                           liste=type(liste_categories),
                           liste_cat=liste_categories)


@app.route('/all_pizzas')
def all_pizzas():
    liste_pizzas = models.vue_pizzas_categories.query.all()
    return render_template('all_pizzas.html', title='Nos Pizzas', liste_pizzas=liste_pizzas)


@app.route('/pizzas_categorie')
def pizzas_categorie():
    id_categ = request.args.get('id_cat')
    liste_pizzas = models.vue_pizzas_categories.query.filter_by(id_cat=id_categ)
    return render_template('pizzas_categorie.html', title='Nos Pizzas', pizzas=liste_pizzas,
                           typeprod=type(liste_pizzas))

@app.route('/ajout_pizza', methods=['GET','POST'])
def ajout_pizza():
    form = pizzaForm()

    #https://flask-wtf.readthedocs.io/en/1.0.x/form/#file-uploads
    if form.validate_on_submit():
        nouvelle_pizza = models.pizza(nom_pizza=form.nom_pizza.data, prix=form.prix.data, id_cat=form.id_cat.data)
        db.session.add(nouvelle_pizza)
        db.session.commit()
    return render_template('ajout_pizza.html',title='Ajout d\'une pizza', form=form)

