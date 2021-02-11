# Chatroom
## Funzionalità aggiuntive.  
Utilizzo di widget apple della libreria Cupertino.  
Colori Differenti per ogni utente.  
E' possibile inviare gif animate.  
Login (account google )tramite l'utilizzo di API firebase e di Google.  
Splash Screen e icona app modificate.  
Utenti online in tempo reale.  
Animazioni per l'entrata dei messaggi.  
## Spiegazione Codice. 
Utilizzo delle API google e di Firebase per creare la shcermata di login attraverso google.(widget Pagina Login).  
Widget bottoneLogin quando premuto fa il login (dopo aver fatto il login grazie a navigator.push passo alla schermata della effettiva chat).  
La classe Chat fa uso delle librerie Cupertino per creare una schermata in stile Apple attraverso widget e icone specifici.  
Il metodo starts collega il client al server o se non raggiungibile tenta nuovamente di connettersi.  
Il metodo inviamessaggio invia i messaggi al server o le varie gif.  
Utenti connessi visualizza la slita degli utenti online.  
_ricevutomessaggio gestisce la ricezione dei messaggi.  
la classe Messaggi e Img servono per andare a utilizzare le animazioni quando i messaggi o le gif vengono ricevute e a formare correttamente la lista dei messaggi.  



