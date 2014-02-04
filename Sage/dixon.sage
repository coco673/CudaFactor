def premiers(base) :
    prems = []
    nb = 0
    while nb < base :
        prems.append(next_prime(nb))
    return prems

def est_dans(liste, x) :
    for k in [0..len(liste)] :
        if liste[k] == x : return True
    return false
    
def est_friable(base,nb) :
    facteurs = list(factor(nb))
    for k in [0,len(facteurs)] :
        p = facteurs[k][0]
        if p > base : return False
    return True
    
def dixon (nb, base) :
    prems = premiers(base)
    k = len(prems)
    r = []
    liste_x = []
    liste_y = []
    liste_v = []
    div = []
    prod = produit(div)
    while prod <> nb :
        x = randint(sqrt(nb),nb)
        m = 0
        while m <> k+1 :
            y = x**2 % nb
            if est_friable(base,y) and not est_dans(div, y) :
                r.append(x,y)
                liste_x.append(x)
                liste_y.append(y)
                m = len(r)
        #for i in range(1,m) :
            #liste_v = # créer les vi,p penser a faire mod 2 ici... 
            
        matrice = matrix(liste_v) 
        e = kernel(matrice) # vecteur non nul noyau de m
        u = prod(liste_x[i] ** (2*e[i]) for i in [1..len(e)]) # produit des xi**(2ei)
        somme_v = sum(v[i]*e[i] for i in range(1, m))
        v = prod(prems[i]**(somme_v/2) for i in range(1, len(prems))) # produit des p**1/2sum(vi,i,1,m)
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
