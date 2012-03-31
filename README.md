# SendGrid Markdown Demo

This is a demo showing how simple it is to use
[SendGrid](http://sendgrid.com/) with [Node.js](http://nodejs.org/).  Using a
simple static file server and websockets, this demo takes emails written in
[Markdown](http://daringfireball.net/projects/markdown/syntax) and sends them
using the SendGrid mail API in real time.

## Install && Setup

This guide assumes you already have node and npm installed. If not, you should
check out [NVM](https://github.com/creationix/nvm) which makes installing them
super easy.

### Step 1: Clone the repo

    git clone git://github.com/theycallmeswift/SendGrid-Markdown-Demo.git
    cd SendGrid-Markdown-Demo

### Step 2: Install the dependencies

    npm install

### Step 3: Edit your SendGrid settings

Open up `config.json` in your favorite editor and fillout the settings.

    {
      "fromAddress": "MarkdownDemo@sendgrid.com",
      "username": "your_sendgrid_username",
      "key": "your_sendgrid_key"
    }

### Step 4: Run locally

    node server.js
