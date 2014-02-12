# -*-coding:Latin-1 -*
#!/usr/bin/env sage -python

import sys
from sage.all import *
from sage import *

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
def dixon (n,base) :
  #  base = Integer(round(sqrt(exp(sqrt(log(n)*log(log(n))))).n()))
    print "base : ", base
    prems = premiers(base)
    print "premierzs : ", prems
    k = len(prems)
    nb = n
    div = []
    prod_div = 1
    while prod_div < n :
        m = 0
        r = []
        liste_v = []
        while m < k+1 :
	    x = randint(floor(sqrt(n)),n)
            y = x**2 % n
            if est_friable(base,y) and not est_dans(div, y) :
                r.append((x,y))
                m = len(r)
        for i in range(0,m) :
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
            #relation_subset = [rel for i,rel in enumerate(r) if z[i] == 1]
            relation_subset = []
	    for i in range(0,len(z)-1) :
		if z[i] == 1 : relation_subset.append((i,r[i]))
            u = 1
            sumvals = k*[0]
            cols_m = column_matrix(matrice)
            for i,x in relation_subset :
                u *= x[0]
                for j,vect in enumerate(cols_m[i]) :
			sumvals[i] += vect
            v = prod(p**(vv//2) for p,vv in zip(prems, sumvals))
            if nb.gcd(u-v) > 1 and nb.gcd(u-v) < nb and (u-v).is_prime() :
                print "u-v" 
                div.append(u-v)                
                #nb = nb/(u-v)
                #div.append(nb)
                break
            elif nb.gcd(u+v) > 1 and nb.gcd(u+v) < nb and (u+v).is_prime() :
                print "u+v"
                div.append(u+v)
                #nb = nb/(u+v)
                #div.append(nb)
                break
            #else : print "erreur"        
        prod_div = prod(div) 
        #print prod_div, div, nb   
    return div
 
 
# 71189, 731021, 757637, 1517, 46570845863, 221

t = cputime(subprocesses=True)
div = dixon(54931, 50)
print "temps d'exécution (en secondes) : ", cputime(t)
print "facteurs : ", div[0], " et ", div[1]
