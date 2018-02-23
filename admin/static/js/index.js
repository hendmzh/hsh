function box(element) {
  if(element) {
    if(element.className=='box') {
      // Si la classe de l'élément est égale à "box", cela signifie qu'il n'est pas déjà cliqué
      // On commence par remettre à zéro tous les éventuels éléments qui auraient déjà été cliqués
      while(document.getElementById('main').getElementsByClassName('box target')[0]) {
        document.getElementById('main').getElementsByClassName('box target')[0].className='box';
      }
      // Ensuite on applique la nouvelle classe qui modifie l'aspect de l'élément
      element.className='box target';
    }
    else
      // Si la classe de l'élément n'est pas égale à "box", c'est soit qu'elle est égale à "box target", soit qu'elle est corrompue (DOM modifié par l'utilisateur).
      // Dans tout les cas, on remet l'élément à zéro
      element.className='box';
  }
}