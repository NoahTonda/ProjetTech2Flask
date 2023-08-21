--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.3

-- Started on 2023-08-21 17:28:43

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- TOC entry 3432 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 234 (class 1255 OID 25045)
-- Name: ajout_pizza(text, real); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ajout_pizza(text, real) RETURNS integer
    LANGUAGE plpgsql
    AS '
declare
  id integer;
  retour integer;
begin
  id=NULL;
  select into id id_pizza from pizza where nom_pizza=$1;
  IF not found
  THEN
    insert into pizza (nom_pizza,prix) values
    ($1,$2);
    retour=1;
    select into id id_pizza from pizza where nom_pizza=$1;
    IF id ISNULL
    THEN
      retour=0;
    END if;
  ELSE 
    retour=0;
  END IF;
  return retour;
end;
';


--
-- TOC entry 235 (class 1255 OID 25046)
-- Name: delete_pizza(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.delete_pizza(integer) RETURNS integer
    LANGUAGE plpgsql
    AS '
	declare p_id_pizza alias for $1;
	declare id integer;
begin
	delete from pizza where id_pizza=f_id_pizza;
	return 1;
end';


--
-- TOC entry 236 (class 1255 OID 25047)
-- Name: isadmin(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.isadmin(text, text) RETURNS boolean
    LANGUAGE plpgsql
    AS '
declare p_login alias for $1; 
declare p_password alias for $2;
declare id integer;
declare retour boolean;

begin
  select into id id_admin from admin where login = p_login and password = p_password;
  if not found
  then
    retour = false;
  else
    retour = true;
  end if;
  return retour;
end;
';


--
-- TOC entry 237 (class 1255 OID 25048)
-- Name: isclient(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.isclient(text, text) RETURNS boolean
    LANGUAGE plpgsql
    AS '
	declare f_login alias for $1;
	declare f_password alias for $2;
	declare id integer;
	declare retour integer;
begin
	select into id id_client from client where email=f_login and password=f_password;
	if not found
	then
	  retour=0;
	else
	  retour=1;
	end if;
	return retour;
end;
';


--
-- TOC entry 238 (class 1255 OID 25049)
-- Name: modif_pizza(integer, text, real); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.modif_pizza(integer, text, real) RETURNS integer
    LANGUAGE plpgsql
    AS '
	declare f_id_pizza alias for $1;
	declare f_nom_pizza alias for $2;
	declare f_prix alias for $3;
	declare retour integer;
	declare id integer;
begin
	select into id id_pizza from pizza where id_pizza=f_id_pizza;
	IF NOT FOUND
	THEN
	  retour=0;
	ELSE
	  update pizza set nom_pizza=f_nom_pizza,prix=f_prix where id_pizza=f_id_pizza;
	  retour=1;
	END IF;
	return retour;

end;';


--
-- TOC entry 239 (class 1255 OID 25050)
-- Name: verifier_connexion(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.verifier_connexion(text, text) RETURNS integer
    LANGUAGE plpgsql
    AS '	declare f_login alias for $1;
	declare f_password alias for $2;
	declare id integer;
	declare retour integer;
begin
	select into id id_admin from admin where login=f_login and password=f_password;
	if not found
	then
	  retour=0;
	else
	  retour=1;
	end if;
	return retour;
end;
';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 214 (class 1259 OID 25051)
-- Name: admin; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin (
    id_admin integer NOT NULL,
    login text,
    password text
);


--
-- TOC entry 215 (class 1259 OID 25056)
-- Name: admin_id_admin_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admin_id_admin_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3433 (class 0 OID 0)
-- Dependencies: 215
-- Name: admin_id_admin_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admin_id_admin_seq OWNED BY public.admin.id_admin;


--
-- TOC entry 231 (class 1259 OID 25150)
-- Name: categorie; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categorie (
    id_cat integer NOT NULL,
    nom_cat character varying
);


--
-- TOC entry 232 (class 1259 OID 25164)
-- Name: categorie_id_categorie_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categorie_id_categorie_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3434 (class 0 OID 0)
-- Dependencies: 232
-- Name: categorie_id_categorie_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categorie_id_categorie_seq OWNED BY public.categorie.id_cat;


--
-- TOC entry 216 (class 1259 OID 25057)
-- Name: client; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client (
    id_client integer NOT NULL,
    nom_client character varying(50),
    prenom_client character varying(50),
    email character varying(50),
    nom_rue character varying(50),
    numero_porte integer,
    id_ville integer NOT NULL,
    password character varying(50) NOT NULL
);


--
-- TOC entry 217 (class 1259 OID 25060)
-- Name: client_id_client_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.client_id_client_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3435 (class 0 OID 0)
-- Dependencies: 217
-- Name: client_id_client_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.client_id_client_seq OWNED BY public.client.id_client;


--
-- TOC entry 218 (class 1259 OID 25061)
-- Name: commande; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.commande (
    id_commande integer NOT NULL,
    prix_total real,
    livree character varying(50),
    id_client integer NOT NULL
);


--
-- TOC entry 219 (class 1259 OID 25064)
-- Name: commande_id_commande_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.commande_id_commande_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3436 (class 0 OID 0)
-- Dependencies: 219
-- Name: commande_id_commande_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.commande_id_commande_seq OWNED BY public.commande.id_commande;


--
-- TOC entry 220 (class 1259 OID 25065)
-- Name: detail; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.detail (
    id_pizza integer NOT NULL,
    id_commande integer NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 25068)
-- Name: ingredient; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ingredient (
    id_ingredient integer NOT NULL,
    nom_ingredient character varying(50)
);


--
-- TOC entry 222 (class 1259 OID 25071)
-- Name: ingrédients_id_ingrédients_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."ingrédients_id_ingrédients_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3437 (class 0 OID 0)
-- Dependencies: 222
-- Name: ingrédients_id_ingrédients_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."ingrédients_id_ingrédients_seq" OWNED BY public.ingredient.id_ingredient;


--
-- TOC entry 223 (class 1259 OID 25072)
-- Name: pizza; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pizza (
    id_pizza integer NOT NULL,
    nom_pizza character varying(50),
    prix real,
    id_cat integer
);


--
-- TOC entry 224 (class 1259 OID 25075)
-- Name: pizza_id_pizza_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pizza_id_pizza_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3438 (class 0 OID 0)
-- Dependencies: 224
-- Name: pizza_id_pizza_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pizza_id_pizza_seq OWNED BY public.pizza.id_pizza;


--
-- TOC entry 225 (class 1259 OID 25076)
-- Name: possede; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.possede (
    id_pizza integer NOT NULL,
    id_ingredient integer NOT NULL
);


--
-- TOC entry 226 (class 1259 OID 25079)
-- Name: pizzaid_ingredient; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.pizzaid_ingredient AS
 SELECT p.id_pizza,
    p.id_ingredient,
    i.nom_ingredient
   FROM (public.possede p
     JOIN public.ingredient i ON ((i.id_ingredient = p.id_ingredient)));


--
-- TOC entry 227 (class 1259 OID 25083)
-- Name: province; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.province (
    id_province integer NOT NULL,
    nom_province character varying(50)
);


--
-- TOC entry 228 (class 1259 OID 25086)
-- Name: province_id_province_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.province_id_province_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3439 (class 0 OID 0)
-- Dependencies: 228
-- Name: province_id_province_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.province_id_province_seq OWNED BY public.province.id_province;


--
-- TOC entry 229 (class 1259 OID 25087)
-- Name: ville; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ville (
    id_ville integer NOT NULL,
    code_postal integer,
    nom_ville character varying(50),
    id_province integer NOT NULL
);


--
-- TOC entry 230 (class 1259 OID 25090)
-- Name: ville_id_ville_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ville_id_ville_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3440 (class 0 OID 0)
-- Dependencies: 230
-- Name: ville_id_ville_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ville_id_ville_seq OWNED BY public.ville.id_ville;


--
-- TOC entry 233 (class 1259 OID 25171)
-- Name: vue_pizzas_categories; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.vue_pizzas_categories AS
 SELECT c.id_cat,
    c.nom_cat,
    p.id_pizza,
    p.nom_pizza,
    p.prix
   FROM public.categorie c,
    public.pizza p
  WHERE (c.id_cat = p.id_cat);


--
-- TOC entry 3236 (class 2604 OID 25165)
-- Name: categorie id_cat; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorie ALTER COLUMN id_cat SET DEFAULT nextval('public.categorie_id_categorie_seq'::regclass);


--
-- TOC entry 3230 (class 2604 OID 25091)
-- Name: client id_client; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client ALTER COLUMN id_client SET DEFAULT nextval('public.client_id_client_seq'::regclass);


--
-- TOC entry 3231 (class 2604 OID 25092)
-- Name: commande id_commande; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commande ALTER COLUMN id_commande SET DEFAULT nextval('public.commande_id_commande_seq'::regclass);


--
-- TOC entry 3232 (class 2604 OID 25093)
-- Name: ingredient id_ingredient; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ingredient ALTER COLUMN id_ingredient SET DEFAULT nextval('public."ingrédients_id_ingrédients_seq"'::regclass);


--
-- TOC entry 3233 (class 2604 OID 25094)
-- Name: pizza id_pizza; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pizza ALTER COLUMN id_pizza SET DEFAULT nextval('public.pizza_id_pizza_seq'::regclass);


--
-- TOC entry 3234 (class 2604 OID 25095)
-- Name: province id_province; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.province ALTER COLUMN id_province SET DEFAULT nextval('public.province_id_province_seq'::regclass);


--
-- TOC entry 3235 (class 2604 OID 25096)
-- Name: ville id_ville; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ville ALTER COLUMN id_ville SET DEFAULT nextval('public.ville_id_ville_seq'::regclass);


--
-- TOC entry 3409 (class 0 OID 25051)
-- Dependencies: 214
-- Data for Name: admin; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.admin (id_admin, login, password) VALUES (1, 'admin', 'admin');


--
-- TOC entry 3425 (class 0 OID 25150)
-- Dependencies: 231
-- Data for Name: categorie; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.categorie (id_cat, nom_cat) VALUES (2, 'cat 2');
INSERT INTO public.categorie (id_cat, nom_cat) VALUES (1, 'cat 1');
INSERT INTO public.categorie (id_cat, nom_cat) VALUES (4, 'cat 3');


--
-- TOC entry 3411 (class 0 OID 25057)
-- Dependencies: 216
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.client (id_client, nom_client, prenom_client, email, nom_rue, numero_porte, id_ville, password) VALUES (9, 'Tonda', 'Noah', 'noahtonda@hotmail.com', 'Wache', 3, 23, 'wxcvbn03');
INSERT INTO public.client (id_client, nom_client, prenom_client, email, nom_rue, numero_porte, id_ville, password) VALUES (10, 'Tonda', 'Noah', 'noahtonda@gmail.com', 'rue de Bouvy', 50, 24, 'wxcvbn03');
INSERT INTO public.client (id_client, nom_client, prenom_client, email, nom_rue, numero_porte, id_ville, password) VALUES (11, 'Tonda', 'Terence', 'terencetonda@hotmail.com', 'Wache', 3, 23, '123');


--
-- TOC entry 3413 (class 0 OID 25061)
-- Dependencies: 218
-- Data for Name: commande; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.commande (id_commande, prix_total, livree, id_client) VALUES (4, 33, 'oui', 9);
INSERT INTO public.commande (id_commande, prix_total, livree, id_client) VALUES (9, 23.5, 'non', 9);


--
-- TOC entry 3415 (class 0 OID 25065)
-- Dependencies: 220
-- Data for Name: detail; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.detail (id_pizza, id_commande) VALUES (67, 4);
INSERT INTO public.detail (id_pizza, id_commande) VALUES (68, 4);
INSERT INTO public.detail (id_pizza, id_commande) VALUES (69, 4);
INSERT INTO public.detail (id_pizza, id_commande) VALUES (66, 4);
INSERT INTO public.detail (id_pizza, id_commande) VALUES (70, 9);
INSERT INTO public.detail (id_pizza, id_commande) VALUES (67, 9);
INSERT INTO public.detail (id_pizza, id_commande) VALUES (66, 9);


--
-- TOC entry 3416 (class 0 OID 25068)
-- Dependencies: 221
-- Data for Name: ingredient; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.ingredient (id_ingredient, nom_ingredient) VALUES (8, 'Anchois');
INSERT INTO public.ingredient (id_ingredient, nom_ingredient) VALUES (12, 'Tomate');
INSERT INTO public.ingredient (id_ingredient, nom_ingredient) VALUES (13, 'Basilic');
INSERT INTO public.ingredient (id_ingredient, nom_ingredient) VALUES (14, 'Buffala');
INSERT INTO public.ingredient (id_ingredient, nom_ingredient) VALUES (15, 'Bolognese');
INSERT INTO public.ingredient (id_ingredient, nom_ingredient) VALUES (16, 'Taleggio');
INSERT INTO public.ingredient (id_ingredient, nom_ingredient) VALUES (17, 'Gorgonzola');
INSERT INTO public.ingredient (id_ingredient, nom_ingredient) VALUES (18, 'Parmesan');
INSERT INTO public.ingredient (id_ingredient, nom_ingredient) VALUES (22, 'Salami');
INSERT INTO public.ingredient (id_ingredient, nom_ingredient) VALUES (23, 'Artichauts');
INSERT INTO public.ingredient (id_ingredient, nom_ingredient) VALUES (24, 'Origan');
INSERT INTO public.ingredient (id_ingredient, nom_ingredient) VALUES (6, 'Champignon');
INSERT INTO public.ingredient (id_ingredient, nom_ingredient) VALUES (2, 'Mozzarella');
INSERT INTO public.ingredient (id_ingredient, nom_ingredient) VALUES (3, 'Jambon');


--
-- TOC entry 3418 (class 0 OID 25072)
-- Dependencies: 223
-- Data for Name: pizza; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pizza (id_pizza, nom_pizza, prix, id_cat) VALUES (66, 'Margherita', 7, 1);
INSERT INTO public.pizza (id_pizza, nom_pizza, prix, id_cat) VALUES (67, 'Prosciutto', 8, 1);
INSERT INTO public.pizza (id_pizza, nom_pizza, prix, id_cat) VALUES (73, 'Napoli', 8, 2);
INSERT INTO public.pizza (id_pizza, nom_pizza, prix, id_cat) VALUES (74, 'Carciofina', 9, 1);
INSERT INTO public.pizza (id_pizza, nom_pizza, prix, id_cat) VALUES (71, 'Calzone', 8.5, 2);
INSERT INTO public.pizza (id_pizza, nom_pizza, prix, id_cat) VALUES (70, 'Bolognese', 8.5, 1);
INSERT INTO public.pizza (id_pizza, nom_pizza, prix, id_cat) VALUES (69, '4 Saisons', 9, 2);
INSERT INTO public.pizza (id_pizza, nom_pizza, prix, id_cat) VALUES (68, '4 Fromages', 9, 4);
INSERT INTO public.pizza (id_pizza, nom_pizza, prix, id_cat) VALUES (75, 'Bufala', 10.5, 4);
INSERT INTO public.pizza (id_pizza, nom_pizza, prix, id_cat) VALUES (72, 'Capricciosa', 8, 4);


--
-- TOC entry 3420 (class 0 OID 25076)
-- Dependencies: 225
-- Data for Name: possede; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (66, 2);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (66, 12);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (66, 13);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (67, 2);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (67, 3);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (67, 12);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (68, 2);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (68, 12);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (68, 16);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (68, 17);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (68, 18);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (69, 2);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (69, 3);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (69, 6);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (69, 12);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (69, 22);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (69, 23);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (70, 2);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (70, 12);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (70, 15);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (71, 2);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (71, 3);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (71, 6);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (71, 12);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (71, 22);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (72, 2);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (72, 3);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (72, 6);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (72, 12);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (73, 2);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (73, 8);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (73, 12);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (73, 24);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (74, 2);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (74, 3);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (74, 12);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (74, 23);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (74, 24);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (75, 12);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (75, 13);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (75, 14);
INSERT INTO public.possede (id_pizza, id_ingredient) VALUES (75, 18);


--
-- TOC entry 3421 (class 0 OID 25083)
-- Dependencies: 227
-- Data for Name: province; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.province (id_province, nom_province) VALUES (1, 'Namur
');
INSERT INTO public.province (id_province, nom_province) VALUES (4, 'Hainaut');


--
-- TOC entry 3423 (class 0 OID 25087)
-- Dependencies: 229
-- Data for Name: ville; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.ville (id_ville, code_postal, nom_ville, id_province) VALUES (16, 5000, 'Namur', 1);
INSERT INTO public.ville (id_ville, code_postal, nom_ville, id_province) VALUES (23, 7110, 'Houdeng-goegnies', 4);
INSERT INTO public.ville (id_ville, code_postal, nom_ville, id_province) VALUES (24, 7100, 'La Louvière', 4);


--
-- TOC entry 3441 (class 0 OID 0)
-- Dependencies: 215
-- Name: admin_id_admin_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.admin_id_admin_seq', 1, false);


--
-- TOC entry 3442 (class 0 OID 0)
-- Dependencies: 232
-- Name: categorie_id_categorie_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categorie_id_categorie_seq', 4, true);


--
-- TOC entry 3443 (class 0 OID 0)
-- Dependencies: 217
-- Name: client_id_client_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.client_id_client_seq', 11, true);


--
-- TOC entry 3444 (class 0 OID 0)
-- Dependencies: 219
-- Name: commande_id_commande_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.commande_id_commande_seq', 11, true);


--
-- TOC entry 3445 (class 0 OID 0)
-- Dependencies: 222
-- Name: ingrédients_id_ingrédients_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."ingrédients_id_ingrédients_seq"', 35, true);


--
-- TOC entry 3446 (class 0 OID 0)
-- Dependencies: 224
-- Name: pizza_id_pizza_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pizza_id_pizza_seq', 78, true);


--
-- TOC entry 3447 (class 0 OID 0)
-- Dependencies: 228
-- Name: province_id_province_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.province_id_province_seq', 4, true);


--
-- TOC entry 3448 (class 0 OID 0)
-- Dependencies: 230
-- Name: ville_id_ville_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ville_id_ville_seq', 24, true);


--
-- TOC entry 3238 (class 2606 OID 25098)
-- Name: admin admin_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (id_admin);


--
-- TOC entry 3256 (class 2606 OID 25156)
-- Name: categorie categorie_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorie
    ADD CONSTRAINT categorie_pk PRIMARY KEY (id_cat);


--
-- TOC entry 3240 (class 2606 OID 25100)
-- Name: client client_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (id_client);


--
-- TOC entry 3242 (class 2606 OID 25102)
-- Name: commande commande_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commande
    ADD CONSTRAINT commande_pkey PRIMARY KEY (id_commande);


--
-- TOC entry 3244 (class 2606 OID 25104)
-- Name: detail detail_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detail
    ADD CONSTRAINT detail_pkey PRIMARY KEY (id_pizza, id_commande);


--
-- TOC entry 3246 (class 2606 OID 25106)
-- Name: ingredient ingrédients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ingredient
    ADD CONSTRAINT "ingrédients_pkey" PRIMARY KEY (id_ingredient);


--
-- TOC entry 3248 (class 2606 OID 25108)
-- Name: pizza pizza_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pizza
    ADD CONSTRAINT pizza_pkey PRIMARY KEY (id_pizza);


--
-- TOC entry 3250 (class 2606 OID 25110)
-- Name: possede possede_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.possede
    ADD CONSTRAINT possede_pkey PRIMARY KEY (id_pizza, id_ingredient);


--
-- TOC entry 3252 (class 2606 OID 25112)
-- Name: province province_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.province
    ADD CONSTRAINT province_pkey PRIMARY KEY (id_province);


--
-- TOC entry 3254 (class 2606 OID 25114)
-- Name: ville ville_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ville
    ADD CONSTRAINT ville_pkey PRIMARY KEY (id_ville);


--
-- TOC entry 3257 (class 2606 OID 25115)
-- Name: client client_id_ville_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_id_ville_fkey FOREIGN KEY (id_ville) REFERENCES public.ville(id_ville);


--
-- TOC entry 3258 (class 2606 OID 25120)
-- Name: commande commande_id_client_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commande
    ADD CONSTRAINT commande_id_client_fkey FOREIGN KEY (id_client) REFERENCES public.client(id_client);


--
-- TOC entry 3259 (class 2606 OID 25125)
-- Name: detail detail_id_commande_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detail
    ADD CONSTRAINT detail_id_commande_fkey FOREIGN KEY (id_commande) REFERENCES public.commande(id_commande);


--
-- TOC entry 3260 (class 2606 OID 25130)
-- Name: detail detail_id_pizza_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.detail
    ADD CONSTRAINT detail_id_pizza_fkey FOREIGN KEY (id_pizza) REFERENCES public.pizza(id_pizza);


--
-- TOC entry 3261 (class 2606 OID 25166)
-- Name: pizza pizza_categorie_null_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pizza
    ADD CONSTRAINT pizza_categorie_null_fk FOREIGN KEY (id_cat) REFERENCES public.categorie(id_cat);


--
-- TOC entry 3262 (class 2606 OID 25135)
-- Name: possede possede_id_ingredient_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.possede
    ADD CONSTRAINT possede_id_ingredient_fkey FOREIGN KEY (id_ingredient) REFERENCES public.ingredient(id_ingredient);


--
-- TOC entry 3263 (class 2606 OID 25140)
-- Name: possede possede_id_pizza_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.possede
    ADD CONSTRAINT possede_id_pizza_fkey FOREIGN KEY (id_pizza) REFERENCES public.pizza(id_pizza);


--
-- TOC entry 3264 (class 2606 OID 25145)
-- Name: ville ville_id_province_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ville
    ADD CONSTRAINT ville_id_province_fkey FOREIGN KEY (id_province) REFERENCES public.province(id_province);


-- Completed on 2023-08-21 17:28:43

--
-- PostgreSQL database dump complete
--

