# ubuntu-basico-para-desenvolvimento

1. Instalação do Docker: https://docs.docker.com/desktop/install/windows-install/
     - Depois da instalação, o programa irá reiniciar a máquina;
     - Haverá um aviso de carência de arquivo. Instalar : wsl_update_x64.msi;

2. Fazer download do zip file no link: https://github.com/rafael-geovista/ubuntu-basico-para-desenvolvimento e "deszipar" em uma pasta dentro da máquina.

3. Abrir o prompt e redirecionar para a pasta onde foi alocado o arquivo baixado do github; (Atentar para colocar aspas dupla no caminho, caso seja necessário). Digitar o seguinte comando: 

    ```
    docker-compose up --build
    ```

    (Esse processo pode demorar 30 min)

4. Depois de finalizado, fechar o cmd e ligar o Docker pela interface gráfica "playstock"

5. Abrir Node-RED pelo browser no endereço http://localhost:1880
6. De forma alternativa, o terminal do Ubuntu criado pode ser acessado com o comando `docker exec -it ubuntu-dev bash`
