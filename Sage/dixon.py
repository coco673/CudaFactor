# -*-coding:Latin-1 -*
#!/usr/bin/env sage -python

import sys
from sage.all import *

#créer la liste des premiers inférieurs à la borne
def premiers(borne) :
    prems = []
    nb = next_prime(0)
    while nb < borne :
        prems.append(nb)
        nb = next_prime(nb)
    return prems

# test : premiers(60000)

# Vérifie la présence de x dans la liste
def est_dans(liste, x) :
    for k in range(0,len(liste)-1) :
        if liste[k] == x : return True
    return false
    
# récupère le 2ème élément du couple (a,b) de le liste quand x = a
def getElem(liste, a) :
    for k in range(0,len(liste)-1) :
        if liste[k][0] == a : return liste[k][1]
    return 0
    
# teste si nb est B-friable
def est_friable(borne,nb) :
    if nb == 0 : return False
    facteurs = list(factor(nb))
    for k in range(0,len(facteurs)-1) :
        p = facteurs[k][0]
        if p > borne : return False
    return True
    
# implémentation de l'algorithme de Dixon
def dixon (nb, base) :
    prems = premiers(base)
    k = len(prems)
    r = []
    liste_v = []
    div = []
    while prod(div[i] for i in range(0,len(div)-1)) != nb :
        m = 0
        while m != k+1 :
	    x = randint(floor(sqrt(nb)),nb)
            y = x**2 % nb
            if est_friable(base,y) and not est_dans(div, y) :
                r.append((x,y))
                m = len(r)
        for i in range(1,m) :
            yy = r[i][0]
            liste_vv = []
            liste_div_y = list(factor(yy))
            for j in range(0,len(prems)-1) :    
                tmp = getElem(liste_div_y, prems[j])
                liste_vv.append(tmp%2)
            vecteur = vector(ZZ,liste_vv)
            liste_v.append(vecteur) # créer les vi,p penser a faire mod 2 ici... 
            
        matrice = matrix(liste_v) 
        e = matrice.right_kernel() # vecteur non nul noyau de m 
        for z in e.basis() :
            relation_subset = [rel for i,rel in enumerate(r) if z[i] == 1]
            u = 1
            sumvals = k*[0]
            for x,val in relation_subset :
                u *= x
                for i,v in enumerate(val) : 
                    sumvals[i] += v
            v = prod(p**(v//2) for p,v in zip(prems, sumvals))
            
            if pgcd > 1 and pgcd < nb :
                div.append(u-v)
                break
            elif nb.gcd(u+v) > 1 and nb.gcd(u+v) < nb :
                    div.append(u+v)
                    break
                #else :
                    # erreur   

    return e

dixon(221,1500)
