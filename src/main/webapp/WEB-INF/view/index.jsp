<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<script src="https://code.jquery.com/jquery-3.5.1.min.js"
        integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0="
        crossorigin="anonymous"></script>

<html>
<style>
    .thSize {
        width: 20px;
    }
    th, td {
        width: 150px;
        border: 1px solid darkgreen;
        text-align: center;
    }
    table, div {
        width: 900px;
        text-align: center;
        border: 1px solid green;
        margin: auto;
    }

</style>
<body>
<h2 style="text-align: center">Todolist</h2>
<table>
    <thead>
    <tr>
        <th class="thSize">Id</th>
        <th>Title</th>
        <th>Text</th>
        <th>Importance</th>
        <th>Delete</th>
        <th>Update</th>
    </tr>
    </thead>
    <tbody></tbody>
    <tfoot>
    <tr>
        <td><input id="id" type="hidden"/></td>
        <td><input id="title" type="text" placeholder="Title"/></td>
        <td><input id="text" type="text" placeholder="Text"/></td>
        <td><label><select id="importance" name="importance">
            <option selected>Choose importance</option>
            <option>1</option>
            <option>2</option>
            <option>3</option>
            <option>4</option>
            <option>5</option>
        </select></label></td>
    </tr>
    <tr>
        <td colspan="4" style="text-align: right">
            <button id="add">Add</button>
        </td>
    </tr>
    </tfoot>

</table>
<hr>
<h2 style="text-align: center">Update form</h2>
<div id="updateForm">
    <input hidden id="updateID">
    <input id="updateTitle">
    <input id="updateText">
    <input id="updateImportanceForm">
    <button id="update">Update</button>
</div>
<script>

    function addButtonDelete(i) {
        let td = document.createElement('td');
        let buttonElement = document.createElement("button");
        buttonElement.className = "del";
        buttonElement.setAttribute("taskId", i);
        const text = document.createTextNode("Delete task " + i);
        buttonElement.append(text);
        td.append(buttonElement)
        return td;
    }

    function addButtonUpdate(i) {
        let td = document.createElement('td');
        let buttonElement = document.createElement("button");
        buttonElement.className = "updated";
        buttonElement.setAttribute("taskIdUpdate", i);
        const text = document.createTextNode("Update task " + i);
        buttonElement.append(text);
        td.append(buttonElement)
        return td;
    }

    function updateTasks(task) {
        document.querySelector('#updateID').value = task.id;
        document.querySelector('#updateTitle').value = task.title;
        document.querySelector('#updateText').value = task.text;
        document.querySelector('#updateImportanceForm').value = task.importance;
    }

    function displayTasks(tasks) {
        console.log(tasks);
        const tbody = document.querySelector('tbody');
        tbody.innerHTML = '';
        tasks.forEach(task => {
            let tr = document.createElement('tr');
            for (const prop in task) {
                let td = document.createElement('td');
                td.append(document.createTextNode(task[prop]));
                tr.append(td);
            }
            tr.append(addButtonDelete(task.id));
            tr.append(addButtonUpdate(task.id));
            tbody.append(tr);
        });
    }

    const baseUrl = "http://localhost:8080/api/v1/tasks";
    fetch(baseUrl)
        .then(response => response.json())
        .then(json => {
            displayTasks(json);

        });

    function addTask(task) {
        let tr = document.createElement('tr');
        for (const prop in task) {
            let td = document.createElement('td');
            td.append(document.createTextNode(task[prop]));
            tr.append(td);
        }
        tr.append(addButtonDelete(task.id));
        tr.append(addButtonUpdate(task.id));
        document.querySelector('tbody').append(tr);
    }

    document.querySelector("#update")
        .addEventListener('click', event => {
            let idInput = document.querySelector('#updateID').value;
            let titleInput = document.querySelector('#updateTitle');
            let textInput = document.querySelector('#updateText');
            let importanceInput = document.querySelector('#updateImportanceForm');
            const task = {
                id: idInput,
                title: titleInput.value,
                text: textInput.value,
                importance: importanceInput.value
            };
            fetch(baseUrl + "/" + idInput, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(task)
            }).then(response => {
                textInput.value = titleInput.value = importanceInput.value = '';
            }).then(allTasks);
        });

    document.querySelector("#add")
        .addEventListener('click', event => {
            let titleInput = document.querySelector('#title');
            let textInput = document.querySelector('#text');
            let importanceInput = document.querySelector('#importance');
            const task = {
                title: titleInput.value,
                text: textInput.value,
                importance: importanceInput.value
            };
            fetch(baseUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(task)
            }).then(response => {
                textInput.value = titleInput.value = importanceInput.value = '';
                return response.json();
            }).then(addTask);
        });

    function allTasks() {
        fetch(baseUrl)
            .then(response => response.json())
            .then(json => {
                displayTasks(json);

            });
    }

    $('tbody').on('click', '.updated', function () {
        let id = $(this).attr("taskIdUpdate");
        console.log(id);
        fetch(baseUrl + "/" + id, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        }).then(response => response.json())
            .then(json => {
                updateTasks(json);
            });
    })

    document.querySelector('table');
    $('table').on('click', '.del', function () {
        let id = $(this).attr("taskId");
        console.log(id);
        fetch(baseUrl + "/" + id, {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json'
            }
        }).then(allTasks);
    });

</script>
</body>
</html>