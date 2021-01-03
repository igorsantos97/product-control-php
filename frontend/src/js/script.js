const url_base = 'http://localhost:8888/backend/index_js.php';
const tableContentDynamic = document.querySelector('.contentDynamic');
const btnLoad = document.querySelector('#btnLoad');
const btnSave = document.querySelector('#btnSave');
const btnReset = document.querySelector('#btnReset');

const inputID = document.querySelector('#inputID');
const inputNome = document.querySelector('#inputDescricao');
const inputValor = document.querySelector('#inputValor');
const inputStatus = document.querySelector('#inputStatus');

function insertProduct() {
    const options = {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `descricao=${inputNome.value}&valor=${inputValor.value}&status=${inputStatus.value}`,
    }
    
    fetch(`${url_base}/produto/`, options)
    .then(response => response.json())
    .then(json => {
        getProducts();
    })
} 

async function getProducts() {
    const dadosResponse = await fetch(`${url_base}/produto`)
    const dadosJson = await (await dadosResponse).json();

    tableContentDynamic.innerHTML = dadosJson.map((item) => `
        <tr>
            <td>${item.ID}</td>
            <td>${item.DESCRICAO}</td>
            <td>${item.VALOR}</td>
            <td>${item.STATUS}</td>
            <td>
                <button class="load btnEdit" id="${item.ID}">Editar</button>
                <button class="alert btnDelete" id="${item.ID}">Excluir</button>
            </td>
        </tr>
    `).join('');

    const buttonsDelete = document.querySelectorAll('.btnDelete');
    buttonsDelete.forEach((button) => {
        button.addEventListener('click', deleteProduct);
    });

    const buttonsEdit = document.querySelectorAll('.btnEdit');
    buttonsEdit.forEach((button) => {
        button.addEventListener('click', editProduct);
    });
}

async function editProduct(e) {
    e.preventDefault();
    const btnID = e.target.id; 
    const {
        ID,
        DESCRICAO, 
        VALOR,
        STATUS
    } = await fetch(`${url_base}/produto/${btnID}`)
    .then(response => response.json())
    .then(json => {
        return json;
    });

    inputID.value = ID;
    inputNome.value = DESCRICAO;
    inputValor.value = VALOR;
    inputStatus.value = STATUS;
}

function deleteProduct(e) {
   e.preventDefault();

   const btnID = e.target.id;
   const options = {
       method: 'DELETE',
       headers: {
           'Content-Type': 'application/json; charset=utf-8',
       }
   }

   if(confirm(`Tem certeza que deseja excluir o produto com o ID ${btnID}?`)) {
       fetch(`${url_base}/produto/${btnID}`, options)
       .then(response => getProducts());
   } else {
      console.log('Cancelado');
   };
}

function updateProduct() {
    if(!inputID.value) {
        insertProduct();
    } else {
        const options = {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `id=${inputID.value}&descricao=${inputNome.value}&valor=${inputValor.value}&status=${inputStatus.value}`,
        }

        console.log(inputID.value, descricao=inputNome.value, valor=inputValor.value, status=inputStatus.value)

        fetch(`${url_base}/produto/`, options)
        .then(response => response.json())
        .then(json => {
            console.log(json);
            getProducts();
        })
    }
}

function resetInputs() {
    inputID.value = ''; 
    inputNome.value = ''; 
    inputValor.value = ''; 
    inputStatus.value = ''; 
}

getProducts();
btnLoad.addEventListener('click', getProducts);
btnSave.addEventListener('click', updateProduct);
btnReset.addEventListener('click', resetInputs);