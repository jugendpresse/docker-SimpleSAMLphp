node {

    def built_image

    def baseimage = 'jugendpresse/apache:php-7.2'

    def image = 'jugendpresse/simplesamlphp'

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */
        checkout scm
    }

    def version = 'latest'

    def old_layers
    def new_layers

    stage('Fetch existing latest docker image') {
        /* Pulls current live image and determines layer ids of that image */
        try {
            def old_image = docker.image( image + ':' + version ).pull()
            def json = sh ( returnStdout: true, script: 'docker inspect ' + image + ':' + version )
            def data = readJSON text: json
            old_layers = data[0]['RootFS']['Layers']
        } catch (exc) {
            old_layers = readJSON text: '[]'
        }
    }

    stage('Build latest image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */
        docker.image( baseimage ).pull()
        built_image = docker.build(image + ':' + version)
    }

    stage('Check latest Image-Layers') {
        def json = sh ( returnStdout: true, script: 'docker inspect ' + image + ':' + version )
        def data = readJSON text: json
        new_layers = data[0]['RootFS']['Layers']
    }

    if ( old_layers != new_layers ) {
        stage('Push image') {
            /* Finally, we'll push the image with two tags:
             * First, the date of the build
             * Second, the 'latest' tag.
             * Pushing multiple tags is cheap, as all the layers are reused. */

            withCredentials([usernamePassword( credentialsId: 'jpdtechnicaluser', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {

                docker.withRegistry('', 'jpdtechnicaluser') {
                    sh "docker login -u ${USERNAME} -p ${PASSWORD}"
                    def date = new Date().format( 'yyyyMMdd-HHmm' )
                    built_image.push()
                    built_image.push( 'dev_' + date )
                }
            }
        }
    }
}
