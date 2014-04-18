# -*- coding: utf-8 -*-
import sys

#dixon14.sage

#Cherche au voisinage de sqrt(i*n)
#Le voisinage n'est pas bien parametre (lim)

#h semble beaucoup trop fort

#n est un nombre impair
#La base integre -1
#
#Le meilleur algo sans essai de filtre

lm=10^7
p = Integer(next_prime(randint(2,lm*10^2)))
q = Integer(next_prime(randint(2,lm)))

t = cputime(subprocesses=True)
n = Integer(sys.argv[1])
div = []
h = Integer(round(sqrt(exp(sqrt(log(n)*log(log(n))))).n())) # borne optimale
off = 0
off = off / 2
h = h // 2

#print h

tb = matrix(h,h+1+off)


def tstcd(b2,li,j):
	global tb,n,div
	r = Integer(b2)
	i = 0
	l = []
	for el in li:
		if i == 0 :
			if r > n / 2 :		
				tb[0,j] = 1
				r = n - r
		else :
			bl = 0
			np = (0,0)
		while (r >= el) :
			av = r
		np = r.quo_rem(el)
		if np[1] != 0 :
			r = av
			break
		else:
			r = np[0]
			tb[i,j]=tb[i,j]+1
			if bl == 0 :
				l.append(i)
				bl = 1
		i = i + 1
	if r != 1 :
		for i in l :
			tb[i,j] = 0
		return -1
	else:
		return 0

def factorDixon(n,h) :
	global tb,li,off,div
	if gcd(2,n) != 1 :
		return 2
	li = [-1,2]
	a = 3
	i=2
	while i < h :
		if gcd(a,n) == a : 
				#print 'TROUVEa'
				#print "facteurs a : ", a
				div.append(a)
				return a
	if n.jacobi(a) == 1:
		li.append(a)
		i = i+1
		a = next_prime(a)
	#print "li : ", li
	N = Integers(n)
	j = 0
	liB = []
	nn = n.ndigits()
	if nn % 2 == 0 :
		nn = nn / 2+1
	else :
		nn = (nn+1) / 2
	strt = ceil(sqrt(n,prec=4*nn))

	rd = strt
	r = 0
	s = 1
	boo = 1
	lim = n // 10
	#print "lim : ",lim
	lam = lim
	while j < h+1+off and s < n-1 :
		if r == lam :
			s = s + 1
			rd = ceil(sqrt(s*n,prec=4*nn))
			#print "s : ", s
			r = 0
			lam = lim // s^2
		if boo == 0 :
			b = N(rd+r)
		else :
			b = N(rd-r)
		gc = gcd(Integer(b),n)
		if gc != 1:
			#print 'TROUVEb'
			#print "facteur b : gcd", gc
			#div.append(gc)
			return gc
		b2 = b * b
		ret = tstcd(b2,li,j)
		if ret == 0 :
			#print 'AAAAA',r
			if boo == 0 :
				liB.append(rd+r)
			else:
				liB.append(rd-r)
			j = j+1
		if boo == 1 :
			r = r+1
			boo = 0
		else:
			boo = 1
	return liB

def tstcd2(bl,h) :
	global tb, div
	for i in range(h) :
		ret = sum(tb[i,j] for j in bl) % 2
		if ret != 0:
			#div.append(ret)
			return ret
	return 0

def searchRoot(n,liB,h):
	global tb,off, div

	ma = matrix(GF(2),map(lambda t:t%2,tb))
	mbl = (ma.right_kernel()).basis()
	for i in range(len(mbl)) :
		bl = []
		#print "mbl[",i,"] : ",mbl[i]
		for j in range(len(mbl[i])):
			if (mbl[i])[j] == 1:
				bl.append(j)
				ret1 = cgr(n,liB,bl)
				if ret1!=-1:
					#print "bl : (searchroot) : ",bl
					div.append(ret1) 
					return ret1
				#else:
					#print "bl : (searchroot) : ",bl
					#print'CONTINUE'
	return -1

li = []
liB = factorDixon(n,h)
#print 'liB : ', liB
def cgr(n,liB,res1):
	global li,tb, div

	if res1 == -1:
		return -1
	cg1 = 1
	for i in res1:
		cg1 *= liB[i] % n

	cg2 = 1
	k = 0
	for i in li:
#       if i != -1:
		ad=0
		for j in res1:
			ad+=tb[k,j]
		cg2 *= i ^ (ad / 2)
		cg2 = cg2 % n
		k = k + 1
	ret = gcd(n,cg2 + cg1)
	if ret != n and ret != 1 :
		#print 'TROUVE'
		#div.append(ret)
		return ret
	else:
		return -1

#print tb
#print liB

div = [] 

if type(liB) == list :
		
	#print 1
	#print "tb : ",tb
	ret=searchRoot(n,liB,h)
	#print "liB : ",liB
	div.append(ret)
	#print "ret final : ", ret
	div.append(ret)
	div.append(n/ret)
else : 
	div.append(liB)
	div.append(n/liB)

print "nombre à factoriser",n
print len(div)
#print "facteurs ", div
s = "facteurs"
for i in range(len(div)) : 
  s = s + ' ' + str(div[i])
print s
print "temps", cputime(t)