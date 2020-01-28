---
layout: default
title: {{ site.name }}
permalink: "team"
---

## **Meet our team!**
----

<div class="row">
  <div class="column">
    <div class="card" >
      <img src="/images/relvas.jpg" alt="image">
      <div class="container">
        <h3> Rodrigo Relvas </h3>
        <p class="title">Project Manager/Developer</p>
        <p></p>
        <p style="font-size:75%;">rodrigo.oliveira@ua.pt</p>
      </div>
    </div>
  </div>

  <div class="column">
    <div class="card">
      <img src="/images/rodas.jpg" alt="image">
      <div class="container">
        <h3>Rodrigo Rocha</h3>
        <p class="title">Developer</p>
        <p></p>
        <p style="font-size:75%;">rocha.rodrigo@ua.pt</p>
      </div>
    </div>
  </div>

  <div class="column">
    <div class="card">
      <img src="/images/fausto.jpg" alt="image">
      <div class="container" >
        <h3>Fábio Nunes</h3>
        <p class="title">Developer</p>
        <p></p>
        <p style="font-size:75%;">fabioalexandrenunes@ua.pt</p>
      </div>
    </div>
  </div>
</div>

<div class="row">
  <div class="column">
    <div class="card">
      <img src="/images/balboa.jpg" alt="image">
      <div class="container">
        <h3>Susana Dias</h3>
        <p class="title">Developer</p>
        <p></p>
        <p style="font-size:75%;">susanadias@ua.pt</p>
      </div>
    </div>
  </div>

  <div class="column">
    <div class="card">
      <img src="/images/di.jpg" alt="image">
      <div class="container">
        <h3>Diana Silva</h3>
        <p class="title">Developer</p>
        <p></p>
        <p style="font-size:75%;">drgs@ua.pt</p>
      </div>
    </div>
  </div>

  <div class="column">
    <div class="card">
      <img src="/images/jon.jpg" alt="image">
      <div class="container">
        <h3>João Jesus</h3>
        <p class="title">Developer</p>
        <p></p>
        <p style="font-size:75%;">jpbjesus@ua.pt</p>
      </div>
    </div>
  </div>
</div>

<style>
    /* Three columns side by side */
    .column {
    float: left;
    width: 33.3%;
    margin-bottom: 16px;
    padding: 0 8px;
    }

    /* Display the columns below each other instead of side by side on small screens */
    @media screen and (max-width: 650px) {
    .column {
        width: 100%;
        display: block;
    }
    }

    /* Add some shadows to create a card effect */
    .card {
    box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
    }

    /* Some left and right padding inside the container */
    .container {
    padding: 0 16px;
    }

    /* Clear floats */
    .container::after, .row::after {
    content: "";
    clear: both;
    display: table;
    }

    .title {
    color: grey;
    }

    .button {
    border: none;
    outline: 0;
    display: inline-block;
    padding: 8px;
    color: white;
    background-color: #000;
    text-align: center;
    cursor: pointer;
    width: 100%;
    }

    .button:hover {
    background-color: #555;
    }
</style>