load dixon.sage

def test() :
    t = cputime(subprocesses=True)
    div = dixon(46570845863)
    print "temps d'exécution (en secondes) : ", cputime(t)
    if prod(div) == 46570845863 : return 1
    else : return 0
    
test()
