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
    
# calcule la borne idéale pour un nombre n passé en argument dans le cadre de l'algo de Dixon
def calcule_borne(n) :
    return Integer(round(sqrt(exp(sqrt(log(n)*log(log(n))))).n()))

# boucle de remplissage de l'ensemble r  
# paramètres : k = taille de l'ensemble des nombres premiers, borne = borne de l'algorithme, n = nombre à factoriser, div = l'ensemble des produits de n déjà trouvés   
def remplir_ens_r(k, borne, n, div) :
    m = 0  
    r = []
    while m < k+1 :
        x = randint(floor(sqrt(n)),n)
        y = x**2 % n
        if est_friable(borne,y) and not est_dans(div, y) :
            r.append((x,y))
            m = len(r)
    return r
    
# remplissage de la matrice
# paramètres : r = ensemble des couples (x,y), prems = liste des nombres premiers utilisés pour l'algo
# remplissage de la matrice
# paramètres : r = ensemble des couples (x,y), prems = liste des nombres premiers utilisés pour l'algo
def remplir_matrice(nb,k,r, prems):
    m = len(r)
    liste_v = []
    liste_v_mod2 = []
    for i in range(0,m) :
        yy = r[i][0]  
        liste_vv = [] # un vecteur Vi,p
        liste_vv_mod2 = [] # un vecteur Vi,p
        liste_div_y = list(factor(yy))
        for j in range(0,len(prems)-1) :    
            tmp = getElem(liste_div_y, prems[j])
            liste_vv.append(tmp)
            liste_vv_mod2.append(tmp%2)
        vecteur = vector(ZZ,liste_vv)
        vecteurMod2 = vector(ZZ,liste_vv_mod2)
        liste_v.append(vecteur) # créer les vi,p penser a faire mod 2 ici...  
        liste_v_mod2.append(vecteurMod2) # créer les vi,p penser a faire mod 2 ici...  
        #if len(liste_v) > 4 : 
        matrice = matrix(liste_v) 
        matriceMod2 = matrix(liste_v_mod2) 
        diviseur = calcule_div_nb(nb,k,matrice, matriceMod2, r, prems)
        if diviseur != -1 : return diviseur
    # construction de la matrice
    #matrice = matrix(liste_v) 
    return -1
  

# calcule des u, v 
# paramètres : n = nombre à factoriser, matrice
def calcule_div_nb(nb,k,matrice, div, r, prems) :
    e = matrice.right_kernel() # vecteur non nul noyau de m         
    for z in e.basis() :
        relation_subset = []        
        for i in range(0,len(z)-1) :
            if z[i] == 1 : relation_subset.append((i,r[i]))
        u = 1
        sumvals = k*[0]
        cols_m = column_matrix(matrice)
        for i,x in relation_subset :
            u = (u * x[0])%nb
            for j,vect in enumerate(cols_m[i]) :
                sumvals[i] += vect
        #v = prod(p**(vv) for p,vv in zip(prems, sumvals))
        v = 1
        for i in range(0, len(prems)-1) : 
            v *= (prems[i]^^(sumvals[i]//2))%nb
        #print "u,v : ", u, v
        u = u%nb
        v = v%nb
        if nb.gcd(u-v) > 1 and nb.gcd(u-v) < nb and (u-v).is_prime() :
	    #print u-v
            return nb.gcd(u-v)
        elif nb.gcd(u+v) > 1 and nb.gcd(u+v) < nb and (u+v).is_prime() :
            #print u+v
            return nb.gcd(u+v)
    return -1
    
# implémentation de l'algorithme de Dixon
def dixon (n) :
    print "nombre à factoriser : ", n
    borne = calcule_borne(n)
    #print "borne : ", borne
    prems = premiers(borne)
    #print "liste des premiers utilisés : ", prems
    k = len(prems)
    nb = n
    div = []
    prod_div = 1
    for i in range(0,len(prems)) : 
	while nb%prems[i] == 0 : 
	    div.append(prems[i])
	    nb /= prems[i]
    if nb.is_prime() :
      div.append(nb)
      return div
    while prod(div) != n :        
        r = remplir_ens_r(k,borne,n,div)   # liste des couples (x,y)
        m = len(r)                         # cardinal de r
        liste_v = [] 
        diviseur = remplir_matrice(nb,k,r, prems) 
        if diviseur != -1 :
            div.append(diviseur)
            nb = nb/diviseur
        if (ceil(nb) == nb) :
            if is_prime(ceil(nb)) :
                div.append(nb)
    return div
    
# Fonction principale de factorisation avec le temps CPU
def main(nb) :
    t = cputime(subprocesses=True)
    div = dixon(nb)
    print "les facteurs : ", div
    print "temps d'exécution (en secondes) : ", cputime(t)
    if prod(div) == nb : return 1
    else : return 0

main(178667)