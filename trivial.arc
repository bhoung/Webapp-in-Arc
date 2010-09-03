; location of blog posts
; header and footer files

(= postdir* "/home/brendan/Webapp-in-Arc/posts/")
(= headerfile* "/home/brendan/Webapp-in-Arc/templates/header.htmlf")
(= footerfile* "/home/brendan/Webapp-in-Arc/templates/footer.htmlf")

; function to read textfile to html page
(def readtext (file)
	(w/infile inf file
		(whiler line (readline inf) nil
			(prn line)
		)
	)
)

; function to print header, blog post and footer, uses readtext
(def prpage (file)
	(readtext headerfile*)
	(let filename (string postdir* (string file))
		(readtext filename)
	)
	(readtext footerfile*)
)                           

; macro to define each page
(mac webpage (title)
	(let file (string title ".htmlf")
		(eval `'(defop ,(fromstring title (read)) req (prpage ,file)))
	)
)       

; for each file in the post directory, find the title and call macro webpage
(each file (dir (string postdir*))     
	(with (title (car (tokens file #\.)))
		(prn "title: " title ".")
		(eval `(webpage ,title))
	)                                  
)           
                        
(= blogtitle* "B's Blog")
                                                  
(mac blogpage body   
  `(tag html 
     (tag head
       (tag title (pr "B's Blog"))
       (gen-css-url)
     )
     (tag header
     	(tag hgroup
     	    (tag h1 (pr "B's Blog"))
     	)
     )
     (center                                           
       (widtable 600 
         (tag b (link blogtitle* ""))
         (br 3)
         ,@body                 
         (br 3)                    
        )
      )
   )
)
          
(defop || req
  (blogpage
    (tag ul
      (each x (dir postdir*) 
      	(with (title (car (tokens x #\.)))        	
      	        (tag li 
      	        (link title)
      	        ;(w/link (pr title) (pr (readfile (postdir*x))))
      	        )
        )           
      )
    )
  )
) 

(def gen-css-url ()
  (prn "<link rel=\"stylesheet\" type=\"text/css\" href=\"webapp.css\">"))
  
(defop webapp.css req
  (pr "
/* HTML5 setup */
article, aside, figure, footer, header, hgroup, nav, section {
    display: block;
}

html {
    background: #F8F8F8;
    color: #3B3B3B;
}

body {
    font-family: Arial, \"Helvetica Neue\", Helvetica, sans-serif;
    padding: 0;
    margin: 0 auto;
    line-height: 1.75;
    word-spacing: 0.1em;
    width: 50%;
}

h1, h2, h3 {
  font-family: Gotham, Calibri, 'Myriad Pro', Arial, Helvetica, sans-serif;
  color: #009EE1;
  text-align: center;
}

h1 {
    letter-spacing:0.1em;
}

p {
    padding: 0;
    margin: 0;
}

article header h2 {
    color: #A1A1A1;
    padding: 1em 0 0 0;
    margin: 0;
}

body > header{
    background-color: rgb(236,235,233);
    color: #505153;
}

nav ul {
    margin: 0;
    padding: 0 1em 0 0;
    text-align: center;
}

nav li {
    display: inline;
    padding-left: 1em;
}

footer {
    text-align:center;
    clear:both;
}"))
 

