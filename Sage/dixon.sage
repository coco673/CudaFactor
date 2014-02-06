# créer la liste des premiers inférieurs à la "base"
def premiers(base) :
    prems = []
    nb = next_prime(0)
    while nb < base :
        prems.append(nb)
        nb = next_prime(nb)
    return prems

# test : premiers(60000)

# Vérifie la présence de x dans la liste
def est_dans(liste, x) :
    for k in [0..len(liste)-1] :
        if liste[k] == x : return True
    return false
    
# teste si nb est B-friable
def est_friable(base,nb) :
    facteurs = list(factor(nb))
    for k in [0,len(facteurs)-1] :
        p = facteurs[k][0]
        if p > base : return False
    return True
    
# implémentation de l'algorithme de Dixon
def dixon (nb, base) :
    prems = premiers(base)
    k = len(prems)
    r = []
    liste_v = []
    div = []
    while prod(div[i] for i in [0..len(div)-1]) <> nb :
        x = randint(floor(sqrt(nb)),nb)
        m = 0
        while m <> k+1 :
            y = x**2 % nb
            if est_friable(base,y) and not est_dans(div, y) :
                r.append((x,y))
                m = len(r)
        #for i in range(1,m) :
            yy = r[i][0]
            liste_vv = []
            liste_div_y = []
            for j in range(len(prems)-1,0) : 
                tmp = yy/p[j]
                if type(tmp) == Integer : liste_div_y.append(tmp)
                yy = tmp
            for j in range(0,len(prems)-1) : 
                 count = 0
                 if est_dans(liste_div_y, prems[j]) :
                     c = liste_div_y.count(prems[j])
                 liste_vv.append(c)
            liste_v.append(liste_vv) # créer les vi,p penser a faire mod 2 ici... 
            
        matrice = matrix(liste_v) 
        e = kernel(matrice) # vecteur non nul noyau de m
        u = prod(r[i][0] ** (2*e[i]) for i in [0..len(e)-1]) # produit des xi**(2ei)
        somme_v = sum(v[i]*e[i] for i in range(0, m-1))
        v = prod(prems[i]**(somme_v/2) for i in range(0, len(prems)-1)) # produit des p**1/2sum(vi,i,1,m)
        pgcd = nb.gcd(u-v)
        if pgcd <> 1 and pgcd <> nb :
            div.append(u-v)
        else :
            pgcd = nb.gcd(u+v)
            if pgcd <> 1 and pgcd <> nb :
                div.append(u-v)
            #else :
                # erreur
    return div

dixon(143,150)
