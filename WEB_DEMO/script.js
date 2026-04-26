var AUDIOBUFFSIZE = 1024;

const SaveTypes = {
	Savestate: "savestate",
	Disk: "disk",
	ISO: "iso",
	BaseImage: "baseimage",
}


class MyClass {
    constructor() {
        this.canvas = document.getElementById('canvas');
        this.ctx = this.canvas.getContext('2d');
		this.rgbaDestination = new Uint8ClampedArray(640 * 480 * 4);
        this.showFPS = true;
        this.onscreenKeyboard = false;
        this.lastHeapLength = 0;
        this.rom_name = '';
        this.rom_size = 0;
        this.iosMode = false;
        this.base_name = '';
        this.initCount = 0;
        this.baseImageSaved = false;
        this.isoSaved = false;
        this.exportFilesRequested = false;
        this.canvasHeight = 480;
        this.ram = 32;
        this.initialHardDrive = 'hd_520';
        this.dosVersion = '7.1';
        this.iso_loaded = false;
        this.noIso = false;
        this.importedFileNames = [];
        this.isSpecialHandler = false;
        this.img_loaded = false;
        this.cueFile = '';
        this.hasBinCue = false;
        this.audioInited = false;
        this.dblistSavestates = [];
        this.dblistBaseImages = [];
        this.dblistIsos = [];
        this.multiFiles = [];
        this.multiFileMode = false;
        this.singleFileUpload = false;
        this.loading = true;
        this.isoName = '';
        this.loginModalOpened = false;
        this.noCloudSave = true;
        this.dosSaveStates = [];
        this.allSaveStates = [];
        this.baseHardDrive = new Uint8Array();
        this.compareCount = 0;
        this.doIntegrityCheck = false;
        this.showLoadAndSavestate = false;
        this.loadSavestateAfterBoot = false;
        this.autoKeyboard = false;
        this.autoKeyboardTimer = 0;
        this.autoKeyboardInterval = 48*180; //three minutes (audioprocessrecurring gets called 48 times a second)
        this.lastCalledTime = new Date();
        this.fpscounter = 0;
        this.currentfps = 0;
        this.fpsInterval = 1000 / 60;
        this.then = Date.now();
        this.hardDiskFallbackFromFloppy = false;
        this.ranWindowsSetup = false;
        this.win95InstallationFix = false;
        this.winNotFoundCommands = '';
        this.doswasmxBatFound = false;

        this.specialFileHandlers = 
        [
            '.7z',
            '.zip',
            '.bin',
            '.cue',
            '.img',
            '.iso'
        ];
        document.getElementById('file-upload').addEventListener('change', this.uploadRom.bind(this));
        document.getElementById('file-import').addEventListener('change', this.importFiles.bind(this));

        this.rivetsData = {
            mobileMode: false,
            darkMode: false,
            inputController: null,
			cpu: 'auto',
            beforeEmulatorStarted: true,
            loggedIn: false,
            romList: [],
            hasCloud: false,
            password: '',
            message: '',
            moduleInitializing: true,
            dblistDisks: [],
            settings: {
                CLOUDSAVEURL: "",
                DEFAULTIMG: ""
            },
            isoMounted: false,
            noLocalSave: true,
            floppyMounted: false,
            isDosMode: true,
            lblError: '',
            initialInstallation: false,
            changeCD: false,
            changeFloppy: false,
            loadFloppy: false,
            noCopyImport: false,
        };

        this.configuration = {
            startupScript: 'CD MECHS\r\nMAIN',
        }

        //comes from settings.js
        this.rivetsData.settings = window["DOSWASMSETTINGS"];

        if (this.rivetsData.settings.CLOUDSAVEURL)
        {
            this.rivetsData.hasCloud = true;
        }

        rivets.formatters.ev = function (value, arg) {
            return eval(value + arg);
        }
        rivets.formatters.ev_string = function (value, arg) {
            let eval_string = "'" + value + "'" + arg;
            return eval(eval_string);
        }

        rivets.bind(document.getElementById('maindiv'), { data: this.rivetsData });
        rivets.bind(document.getElementById('importModal'), { data: this.rivetsData });
        rivets.bind(document.getElementById('loginModal'), { data: this.rivetsData });
        rivets.bind(document.getElementById('settingsModal'), { data: this.rivetsData });
        rivets.bind(document.getElementById('divInstructions'), { data: this.rivetsData });
        rivets.bind(document.getElementById('mobileDiv'), { data: this.rivetsData });
        rivets.bind(document.getElementById('mobileButtons'), { data: this.rivetsData });
        

        this.detectBrowser();

        if (this.rivetsData.hasCloud)
        {
            this.setupLogin();
            let hours = new Date().getHours();
            if (hours < 7 || hours > 20)
            {
                this.btnDarkMode();
            }
        }


        $('#topPanel').show();
        $('#errorOuter').show();
        
    }

    btnDarkMode(){

        this.rivetsData.darkMode = !this.rivetsData.darkMode;
        
        if (this.rivetsData.darkMode)
        {
            $("body").addClass("darkMode");
        }
        else
        {
            $("body").removeClass("darkMode");
        }
    }

    detectBrowser(){
        if (navigator.userAgent.toLocaleLowerCase().includes('iphone'))
        {
            this.iosMode = true;
            try {
                let iosVersion = navigator.userAgent.substring(navigator.userAgent.indexOf("iPhone OS ") + 10);
                iosVersion = iosVersion.substring(0, iosVersion.indexOf(' '));
                iosVersion = iosVersion.substring(0, iosVersion.indexOf('_'));
                this.iosVersion = parseInt(iosVersion);
            } catch (err) { }
        }
        if (window.innerWidth < 600 || this.iosMode)
            this.rivetsData.mobileMode = true;
        else
            this.rivetsData.mobileMode = false;

        // firefox only supports 250 megs??
        if (navigator.userAgent.toLocaleLowerCase().includes('firefox'))
        {
            this.initialHardDrive = 'hd_250';
        }

        if (this.iosMode)
        {
            this.initialHardDrive = 'hd -size 25';
        }

        if (this.rivetsData.mobileMode)
        {
            this.canvasHeight = window.innerWidth / 2;
            console.log('detected mobile mode - canvasheight: ' + this.canvasHeight)
        }
    }

    preventDefaults(e){
        e.preventDefault();
        e.stopPropagation();
    }

    handleProgress(event, file){ }

    configureEmulator(){

        if (this.rivetsData.password)
            this.loginSilent();

        let size = localStorage.getItem('doswasmx-height');
        if (size) {
            console.log('size found');
            let sizeNum = parseInt(size);
            this.canvasHeight = sizeNum;
        }

        if (this.rivetsData.mobileMode)
        {
            this.setupMobileMode();
            $('#githubDiv').hide();
            $('#errorMobile').show();
        }
        else
        {
            $('#divInstructions').show();
        }

        this.resizeCanvas();

        $('#canvasDiv').show();

        this.rivetsData.inputController.setupMouseMode();
        this.rivetsData.inputController.setupGamePad();

        //start raf loop
        this.onAnimationFrame();
    }
        
    onAnimationFrame() {

        window.requestAnimationFrame(myClass.onAnimationFrame);

        myClass.rivetsData.inputController.processGamepad();
        myClass.rivetsData.inputController.updateControls();
    }

    processPrintStatement(text) {
        console.log(text);

        if (text.includes('globalOnscreenKeyboard'))
        {
            if (text == 'globalOnscreenKeyboard 0')
            {
                this.onscreenKeyboard = false;
            }
            else
            {
                this.onscreenKeyboard = true;
            }
        }

        if (text.includes('Mouse speed'))
        {
            const floatNumber = parseFloat(text.substr(text.indexOf('speed')+6));
            let percent = (floatNumber*100).toFixed(0);
            let newText = 'Mouse Sensitivity ' + percent + '%';
            
            //showToast doesn't work with weird characters
            toastr.success(newText);
            myClass.showToast(percent + ' percent');
        }

        if (text.includes('Emulation speed'))
        {
            let percent = text;
            percent = percent.substr(percent.indexOf('(')+1);
            percent = percent.substr(0,percent.indexOf('%'));

            //showToast doesn't work with weird characters
            toastr.success(percent + ' percent');
            myClass.showToast(percent + ' percent');
        }

        //they tried to load an .img file that turned out to be a floppy disk
        if (text.includes('detected floppy disk'))
        {
            if (this.rivetsData.dblistDisks.length == 0 && !this.rivetsData.settings.DEFAULTIMG)
            {
                //this means they don't have a hard disk
                myClass.base_name = 'mydisk';
                myClass.rivetsData.initialInstallation = true;
            }
            else
            {
                //fall back to using their hard drive
                myClass.base_name = 'mydisk';
                myClass.hardDiskFallbackFromFloppy = true;
            }
        }

        //we detected a floppy disk
        if (text.includes('floppy disk mounted'))
        {
            setTimeout(() => {
                if (myClass.rivetsData.initialInstallation)
                {
                    myClass.sendDosCommands(
                        'imgmake \"' + this.base_name + ".img\" -t " + this.initialHardDrive + "\n" +
                        'imgmount c \"' + this.base_name + ".img\na:\n");
                }
                else if (myClass.hardDiskFallbackFromFloppy)
                {
                    //if they already have a hard disk we load it
                    //currently does not support this.rivetsData.settings.DEFAULTIMG + dragging .img floppy
                    if (this.rivetsData.dblistDisks.length > 0)
                    {
                        this.loadFromDatabase(SaveTypes.Disk);
                    }
                }
                else
                {
                    myClass.sendDosCommands("a:\n");
                }
                myClass.rivetsData.floppyMounted = true;
            }, 
            
            //TODO this is a hack
            //dos commands should queue up rather
            //than overwrite eachother
            500);
        }



        //this means we detected the windows cd
        if (text.includes("iso mounted root file: WIN98") || text.includes("iso mounted root file: WIN95"))
        {
            //auto start the setup process - only do this once
            if (!myClass.ranWindowsSetup)
            {
                myClass.ranWindowsSetup = true;
                setTimeout(() => {
                    myClass.rivetsData.initialInstallation = true;
                    myClass.sendDosCommands("d:setup.exe\n");
                }, 50);

                //set cpu to max during windows installation
                setTimeout(() => {
                    myClass.updateCpuNeil('cycles=max');
                }, 100);
            }
        }

        if (text.includes('windows not found') || text.includes('found noboot.txt'))
        {
            //if we don't detect a windows installation just send
            //them to the C drive
            setTimeout(() => {

                let dosCommands = "c:\n";

                //if we found a DOSWASMX.BAT we run it
                if (myClass.doswasmxBatFound)
                {
                    dosCommands += 'doswasmx.bat\n'
                }

                //add any additional commands appended based on the rom file
                dosCommands += myClass.winNotFoundCommands;

                //send it to the dos shell
                myClass.sendDosCommands(dosCommands);

                //clear it for next time
                myClass.winNotFoundCommands = '';
            }, 50);
        }

        if (text.includes('Parsing command line: d:setup.exe'))
        {
            //a bunch of hacks to get it to dismiss the install
            //warnings for win95rtm, win95osr2, and win98se
            if (myClass.rivetsData.initialInstallation)
            {
                setTimeout(() => {
                    myClass.sendKey(52); //enter
                }, 1000); 
                setTimeout(() => {
                    myClass.sendKey(49); //escape
                }, 3000);
                setTimeout(() => {
                    myClass.sendKey(52); //enter
                }, 3100);
            }
        }

        if (text.includes('Plug & Play OS reports itself inactive'))
        {
            //this is hack during windows 95 installation 
            //where it doesnt detect one of the restarts
            if (myClass.rivetsData.initialInstallation && !myClass.win95InstallationFix)
            {
                console.log('windows95 fix');
                myClass.win95InstallationFix = true;
                setTimeout(() => {
                    myClass.updateAutoexecAdditional("boot c:\n");
                    // myClass.saveDrive();    
                }, 100);
            }
        }

        if (text.includes('drive mounted C file: DOSWASMX.BAT'))
        {
            myClass.doswasmxBatFound = true;
        }

        if (text.includes('x =='))
        {
            if (text.includes('x == 2'))
            {
                //this means we are booting into windows
                myClass.rivetsData.isDosMode = false;
            }            
            else
            {
                if (text.includes('x == 0'))
                {
                    //this means we explicitly selected shutdown so go to DOS
                }
                else
                {
                    //otherwise they probably picked restart
                    //so send them back to windows
                    setTimeout(() => {
                        myClass.updateAutoexecAdditional("boot c:\n");
                    }, 100);
                }

                //save the hard disk every time we restart/shutdown
                if (!myClass.rivetsData.loggedIn)
                {
                    setTimeout(() => {
                        myClass.saveDrive();    
                    }, 100);
                }

                //we are back to the dos shell
                myClass.rivetsData.isoMounted = false;
                myClass.rivetsData.floppyMounted = false;
                myClass.rivetsData.isDosMode = true;
            }
        }

        if (text.includes('iso drive mounted'))
        {
            //we mounted a cd
            myClass.rivetsData.isoMounted = true;
        }

        //emulator has started event
        if (text.includes('DEBUG_ShowMsg: pixratio 1.000')
            && myClass.loadSavestateAfterBoot) {
            console.log('detected windows started');
            myClass.loadSavestateAfterBoot = false;

            if (myClass.rivetsData.loggedIn && !myClass.noCloudSave)
            {
                //we give it a 5 second delay because we
                //want to wait for the windows startup sound
                setTimeout(() => {
                    myClass.loadCloud();
                }, 5000);
            }
        }

        //this means its done exporting
        if (text.includes('echo DONE'))
        {
            if (this.exportFilesRequested)
            {
                this.exportFilesRequested = false;
                setTimeout(() => {
                    let filearray = Module.FS.readFile("/export.zip");    
                    var file = new File([filearray], "export.zip", {type: "text/plain; charset=x-user-defined"});
                    saveAs(file);
                    Module._neil_clear_autoexec();
                }, 500);
            }
        }

        //this means its done importing
        if (text.includes('echo Import Finished'))
        {
            setTimeout(() => {
                Module._neil_clear_autoexec();
            }, 500);
        }
    }

    async initModule(){
        myClass.initCount++;
        myClass.finishInitialization();
        console.log('module initialized');
    }

    //need to wait for both indexedDB and wasm runtime
    finishInitialization()
    {
        if (myClass.initCount == 2)
        {
            myClass.rivetsData.moduleInitializing = false;
            myClass.rivetsData.message = '';

            $('#githubDiv').show();
            this.loading = false;

        }        
    }

    detectSingleFileUpload(fileName) {
        let fileExtension = fileName.substr(fileName.lastIndexOf('.')).toLocaleLowerCase();
        if (!this.specialFileHandlers.includes(fileExtension))
        {
            myClass.singleFileUpload = true;
        }
    }

    checkIfImgMakeNeeded(files)
    {
        let hasImgFile = false;

        for(let i = 0; i < files.length; i++)
        {
            if (files[i].name.toLocaleLowerCase().endsWith('img'))
            {
                hasImgFile = true;
            }
        }

        if (!hasImgFile && !myClass.rivetsData.settings.DEFAULTIMG)
        {
            myClass.rivetsData.initialInstallation = true;
        }
    }

    uploadRom(event) {

        myClass.checkIfImgMakeNeeded(event.currentTarget.files);
        
        myClass.Run();
        myClass.rivetsData.showProgress = true;

        if (event.currentTarget.files.length == 1)
        {
            myClass.detectSingleFileUpload(event.currentTarget.files[0].name);
        }
        else if (event.currentTarget.files.length > 1)
        {
            myClass.handleMultipleFiles(event.currentTarget.files, 0);
            return;
        }

        var file = event.currentTarget.files[0];
        myClass.rom_name = file.name;
        myClass.extractBaseName();

        console.log(file);
        var reader = new FileReader();
        reader.onprogress = function (event) { };
        reader.onload = function (e) {
            console.log('finished loading');
            var byteArray = new Uint8Array(this.result);
            myClass.LoadEmulator(byteArray);
        }
        reader.readAsArrayBuffer(file);
    }

    async parseMultipleFiles()
    {
        console.log('parseMultipleFiles', this.multiFiles);
        this.multiFileMode = true;

        //set some baseline default
        this.rom_name = 'blank.txt';
        let firstBytes = new Uint8Array(5);
        this.extractBaseName();



        for(let i = 0; i < this.multiFiles.length; i++)
        {
            let file = this.multiFiles[i];

            if (file.name.toLocaleLowerCase().endsWith('img'))
            {
                //we prioritize the img name as the rom_name
                //because we want to be sure it uses this as the
                //hard drive when it gets to the LoadEmulator stage
                this.rom_name = file.name;
                this.extractBaseName();

                this.baseHardDrive = file.data;
                let finalByteArray = await this.loadHardDriveDiffs(file.data);
                Module.FS.writeFile('/' + this.base_name + '.img',finalByteArray);

                this.img_loaded = true;
            }
            else if (
                file.name.toLocaleLowerCase().endsWith('iso') || 
                file.name.toLocaleLowerCase().endsWith('.cue'))
            {
                Module.FS.writeFile('/' + file.name,file.data);
                this.isoName = file.name;

                if (file.name.toLocaleLowerCase().endsWith('.cue'))
                {
                    this.hasBinCue = true;
                    this.cueFile = file.name;    
                }

                //if we didn't find an img then use this as the rom_name
                if (!this.rom_name)
                {
                    this.rom_name = file.name;
                    this.extractBaseName();
                }
            }
            else
            {
                //except bin/cue files
                if (file.name.toLocaleLowerCase().endsWith('.bin') )
                {
                    //will handle these manually
                    Module.FS.writeFile('/' + file.name,file.data);
                }
                else
                {
                    //put them in the uploaded folder
                    Module.FS.writeFile('/uploaded/' + file.name,file.data);
                }
                
            }
        }

        //FREE THE MEMORY
        this.multiFiles = null;

        //we want to avoid setting the iso bytes because they were set above
        this.noIso = true;

        this.LoadEmulator(firstBytes);

    }

    handleMultipleFiles(files, index) {

        var file = files[index];
        console.log('processing file ' + (index+1) + ' of ' + files.length, file);

        var reader = new FileReader();

        reader.onprogress = function (event) {
            // console.log('loaded: ' + event.loaded);
            let loaded = event.loaded;
            let total = event.total;
            let percent = (loaded / total)*100;

            loaded = Math.ceil(loaded / 1000000);
            total = Math.ceil(total / 1000000);

            let formatted = '(' + (index+1) + ' of ' + files.length + ') ' +
                file.name + ' ' + loaded + 'MB / ' + total + 'MB';
            
            document.getElementById('myProgress').style.width= percent + '%';
            document.getElementById('myProgress').innerHTML = formatted;
        };
        reader.onload = function (e) {
            var byteArray = new Uint8Array(this.result);
            myClass.multiFiles.push(
                {
                    name: file.name,
                    data: byteArray
                }
            )
            if ( (index+1)<files.length)
            {
                myClass.handleMultipleFiles(files, index + 1);
            }
            else
            {
                myClass.parseMultipleFiles();
            }

        }
        reader.readAsArrayBuffer(file);
    }


    //awful spaghetti code needs major refactoring!
    async LoadEmulator(byteArray){
        console.log('LoadEmulator');


        if (byteArray && byteArray.length)
        {
            this.rom_size = byteArray.length;
        }

        if (this.iso_loaded == false)
        {
            if (!this.noIso)
            {
                if (this.rom_name.toLocaleLowerCase().endsWith('.img'))
                {
                    this.baseHardDrive = byteArray;
                    let finalByteArray = await this.loadHardDriveDiffs(byteArray);
                    Module.FS.writeFile('/' + this.base_name + '.img',finalByteArray);
                }
                else
                {
                    if (this.singleFileUpload)
                        Module.FS.writeFile('/uploaded/' + myClass.rom_name,byteArray);
                    else
                    {
                        Module.FS.writeFile('/' + myClass.rom_name,byteArray);
                    }
                }
            }

            this.iso_loaded = true;



            if (this.rom_name.toLocaleLowerCase().endsWith('.img'))
            {
                //we prioritize drag/dropping an img
                //then we skip loading img
                this.img_loaded = true;
                this.noIso = true;
                this.LoadEmulator();
            }
            else if (this.rivetsData.initialInstallation || !this.rivetsData.loggedIn)
            {

                if (this.rivetsData.dblistDisks.length == 0)
                {
                    if (this.rivetsData.settings.DEFAULTIMG)
                    {
                        this.load_file(this.rivetsData.settings.DEFAULTIMG);
                    }
                    else
                    {
                        //this means it is their initial windows installation
                        this.img_loaded = true;
                        this.rivetsData.initialInstallation = true;
                        this.LoadEmulator();
                    }
                }
                else
                {
                    //load their disk
                    this.loadFromDatabase(SaveTypes.Disk);
                }

            }            
            else
            {
                this.load_file(this.base_url + this.base_name + '.img');
            }

            return;

        }
        if (this.img_loaded == false)
        {
            //this will be the base hard drive for applying diffs
            this.baseHardDrive = byteArray;

            let finalByteArray = await this.loadHardDriveDiffs(byteArray);
            Module.FS.writeFile('/' + this.base_name + '.img',finalByteArray);

            this.img_loaded = true;
        }

        //write font file
        let responseText = await $.ajax({
                url: 'main.ttf',
                beforeSend: function (xhr) {
                xhr.overrideMimeType("text/plain; charset=x-user-defined");
                }
            });
        let responseBytes = new Uint8Array(responseText.length);
        for (let i = 0; i < responseText.length; i++) {
            responseBytes[i] = responseText.charCodeAt(i) & 0xff;
        }
        console.log('main.ttf',responseText.length);
        Module.FS.writeFile('/res/arial.ttf',responseBytes);


        //write dosbox.conf
        var rando = Math.floor(Math.random() * Math.floor(100000));
        let file = './dosbox.conf';
        responseText = await $.ajax({
            url: './' + file,
            beforeSend: function (xhr) {
                xhr.overrideMimeType("text/plain; charset=x-user-defined");
            }
        });
        console.log(file,responseText.length);


        let multiFileScript = '';
        if (this.multiFileMode)
        {
            //we want to copy the files to the C drive
            multiFileScript = 
                'mount e .\r\n' +
                'xcopy e:\\uploaded\\*.* c:\\uploaded /I /E\r\nmount -u e\r\n';
            if (this.noIso && this.isoName)
            {
                multiFileScript += 'imgmount d \"' + this.isoName + '\"\r\n';
            }
        }

        if (this.configuration.startupScript)
        {
            multiFileScript += this.configuration.startupScript.replace(/;/g, '\r\n');
        }

        if (this.rivetsData.initialInstallation)
        {
            if (this.rom_name.toLocaleLowerCase().endsWith('.iso'))
            {
                responseText = responseText.replace('[autoexec]',
                    '[autoexec]\r\nimgmount d \"' + this.rom_name +
                    '\"\r\nECHO Initial Install\r\n' + 
                    'imgmake \"' + this.base_name + ".img\" -t " + this.initialHardDrive + "\r\n" +
                    'imgmount c \"' + this.base_name + ".img\"\r\nd:\r\n");
            }
            else if (this.hasBinCue)
            {
                responseText = responseText.replace('[autoexec]',
                    '[autoexec]\r\nimgmount d \"' + this.cueFile + '\"\r\n' +
                    '\"\r\nECHO Initial Install\r\n' + 
                    'imgmake \"' + this.base_name + ".img\" -t " + this.initialHardDrive + "\r\n" +
                    'imgmount c \"' + this.base_name + ".img\"\r\nd:\r\n");
            }
            else if (this.rom_name.toLocaleLowerCase().endsWith('.img'))
            {
                responseText = responseText.replace('[autoexec]',
                    '[autoexec]\r\nimgmount c \"' + this.rom_name + '\"\r\n' +
                    'c:\r\n' +
                    'boot c:');
            }
            else if (this.rom_name.toLocaleLowerCase().endsWith('.zip') ||
                     this.rom_name.toLocaleLowerCase().endsWith('.7z'))
            {
                let sanitized = this.sanitizeName(this.rom_name);

                // we want to always copy to the C drive so that 
                // Save Drive will save our changes 
                responseText = responseText.replace('[autoexec]',
                    '[autoexec]\r\nmount d \"' + this.rom_name + '\"\r\n' +
                    'imgmake \"' + this.base_name + ".img\" -t " + this.initialHardDrive + "\r\n" +
                    'imgmount c \"' + this.base_name + ".img\"\r\n" +
                    'XCOPY D:\ C:\\' + sanitized + ' /I /E\r\nmount -u d\r\n' +
                    'c:\r\ncd ' + sanitized + '\r\n');

                if (this.configuration.startupScript)
                {
                    responseText += this.configuration.startupScript.replace(/;/g, '\r\n');
                }
            }
            else
            {
                responseText = responseText.replace('[autoexec]',
                    '[autoexec]\r\n' +
                    'imgmake \"' + this.base_name + ".img\" -t " + this.initialHardDrive + "\r\n" +
                    'imgmount c \"' + this.base_name + ".img\r\n" +
                    'mount e .\r\n' +
                    'e:\r\ncd uploaded\r\n'
                    //the reason we don't want to copy to the c drive on initial install
                    //is because the copy operation is super slow
                    //'xcopy e:\\uploaded\\*.* c:\\uploaded /I /E\r\nmount -u e\r\nc:\r\ncd uploaded\r\n'
                    );
            }
        }
        else if (this.noIso)
        {
            responseText = responseText.replace('[autoexec]',
                '[autoexec]\r\nimgmount c \"' + this.base_name +
                '.img\"\r\n' + multiFileScript + 'boot c:');
        }
        else if (this.rom_name.toLocaleLowerCase().endsWith('.iso'))
        {
            responseText = responseText.replace('[autoexec]',
                '[autoexec]\r\nimgmount c \"' + this.base_name +
                '.img\"\r\nimgmount d \"' + this.base_name +
                '.iso\"\r\n' + multiFileScript + 'boot c:');
        }
        else if (this.rom_name.toLocaleLowerCase().endsWith('.zip') || 
                 this.rom_name.toLocaleLowerCase().endsWith('.7z'))
        {
            let sanitized = this.sanitizeName(this.rom_name);

            responseText = responseText.replace('[autoexec]',
                '[autoexec]\r\nimgmount c \"' + this.base_name +
                '.img\"\r\nmount d \"' + this.rom_name +
                '\"\r\nXCOPY D:\ C:\\' + sanitized + ' /I /E\r\n' +
                'mount -u d\r\n' + multiFileScript + 'boot c:');
            this.winNotFoundCommands = 'cd ' + sanitized + '\r\n';
        }
        else
        {
            //if it's a single unremarkable file we just copy it to C:
            if (this.singleFileUpload)
            {
                multiFileScript = 
                    'mount e .\r\n' +
                    'xcopy e:\\uploaded\\*.* c:\\uploaded /I /E\r\nmount -u e\r\n';
            }

            //as a last resort we always atleast try to boot into windows
            responseText = responseText.replace('[autoexec]',
                '[autoexec]\r\nimgmount c \"' + this.base_name +
                '.img\"\r\n' + multiFileScript + 'boot c:');
        }

        //ram override
        responseText = responseText.replace("memsize=32","memsize=" + this.ram);

        //dos version override
        responseText = responseText.replace("ver=7.1","ver=" + this.dosVersion);

        //cpu override
        responseText = responseText.replace("cycles=auto","cycles=max");
        
        // console.log(responseText);
		Module.FS.writeFile('dosbox.conf',responseText);

        this.WriteConfigFile();

        this.updateAutoexecAdditional = Module.cwrap('neil_update_autoexec_additional', null, ['string']);
        this.showToast = Module.cwrap('neil_show_toast', null, ['string']);
        this.sendKey = Module.cwrap('neil_send_key', null, ['number']);
        this.updateCpuNeil = Module.cwrap('neil_update_cpu', null, ['string']);
        this.changeIso = Module.cwrap('neil_change_iso', null, ['string']);
        this.changeFloppyDisk = Module.cwrap('neil_change_floppy', null, ['string']);
        this.loadFloppyDisk = Module.cwrap('neil_load_floppy', null, ['string']);
        this.sendDosCommands = Module.cwrap('neil_send_dos_commands', null, ['string']);
        this.sendMouseMovement = Module.cwrap('neil_send_mouse_movement', null, ['number','number']);
        this.sendDosControls = Module.cwrap('neil_send_dos_controls', null, 
            ['string','string','string','array','number','string','string']); //arrays are always unsigned byte arrays

        Module.callMain();
        this.configureEmulator();
        this.rivetsData.beforeEmulatorStarted = false;
        
    }

    sanitizeName(name){
        
        //get rid of the extension
        if (name.includes('.'))
        {
            name = name.substr(0,name.lastIndexOf('.'))
        }

        //get rid of non alphanumeric and make it uppercase
        name = name.replace(/[^0-9a-z]/gi, '').toLocaleUpperCase();

        //trim
        if (name.length > 6)
        {
            name = name.substr(0,6);
        }
        else if (name.length<3) // as long as its atleast 3 long we leave it
        {
            //fill in the gaps with random numbers
            var rando = Math.floor(Math.random() * Math.floor(100000));
            name += rando;
            if (name.length > 6) name = name.substr(0,6);
        }

        return name;
    }

    readRomProp(key){
        let myselect = document.getElementById('romselect');
        try
        {
            return myselect.options[myselect.selectedIndex].attributes[key].value;
        }
        catch(err)
        {
            return '';
        }
    }

    async loadRom(noIso) {
        
        this.Run();
        

        if (noIso)
        {
            this.noIso = true;
            this.LoadEmulator();
        }
        else
        {
            let romurl = this.readRomProp("value");
            let startupScript = this.readRomProp("startupScript");
            let cpu = this.readRomProp("cpu");
            let ram = this.readRomProp("ram");
            let harddrive = this.readRomProp("harddrive");

    
            if (startupScript) this.configuration.startupScript = startupScript;
            if (cpu) this.rivetsData.cpu = cpu;
            if (ram) this.ram = ram;
            if (harddrive) this.initialHardDrive = harddrive;
    
            console.log(this.configuration);

            this.rom_name = this.extractRomName(romurl);

            if (romurl.toLocaleLowerCase().startsWith('http'))
            {
                this.base_url = romurl.substr(0, romurl.lastIndexOf('/')+1);
            }

            this.extractBaseName();

            this.load_file(romurl);
        }
    }
 
    countFPS(){
        this.fpscounter++;
        let delta = (new Date().getTime() - this.lastCalledTime.getTime())/1000;
        if (delta>1)
        {
            this.currentfps = this.fpscounter;
            this.fpscounter = 0;
            this.lastCalledTime = new Date();

            console.log(this.currentfps);
        }
    }

    extractBaseName(){
        try
        {
            this.base_name = this.rom_name.substr(0,this.rom_name.lastIndexOf('.'));
        }
        catch{
            this.base_name = 'blank';
        }
    }

    async load_file(path) {

        console.log('loading ' + path);
        myClass.load_url_request(path);
    }

    load_url_request(path){

        //check cache
        let cleanPath = path.substr(path.lastIndexOf('/')+1);
        if (cleanPath.endsWith('.img'))
        {
            let baseImageName = cleanPath.replace(".img",".baseimage");
            if (myClass.dblistBaseImages.includes(baseImageName))
            {
                myClass.loadFromDatabase(SaveTypes.BaseImage);
                return;
            }
        }
        if (cleanPath.endsWith('.iso'))
        {
            if (myClass.dblistIsos.includes(cleanPath))
            {
                myClass.loadFromDatabase(SaveTypes.ISO);
                return;
            }
        }
        if (cleanPath.endsWith('.zip'))
        {
            if (!myClass.rivetsData.settings.DEFAULTIMG)
            {
                myClass.rivetsData.initialInstallation = true;
            }
        }

        this.rivetsData.showProgress = true;

        var req = new XMLHttpRequest();
        req.open("GET", path);
        req.overrideMimeType("text/plain; charset=x-user-defined");
        req.onerror = () => console.log(`Error loading ${path}: ${req.statusText}`);
        req.responseType = "arraybuffer";

        req.onprogress = function (event) {
            let loaded = event.loaded;
            let total = event.total;
            let percent = (loaded / total)*100;

            loaded = Math.ceil(loaded / 1000000);
            total = Math.ceil(total / 1000000);

            let formatted = loaded + 'MB / ' + total + 'MB';
            
            document.getElementById('myProgress').style.width= percent + '%';
            document.getElementById('myProgress').innerHTML = formatted;
        };
        req.onload = function (e) {
            console.log('request loaded',e,req);
            var arrayBuffer = req.response; // Note: not oReq.responseText
            try{
                if (req.status==404)
                {
                    console.log('request returned 404');

                    // TODO - this code might not work anymore
                    if (myClass.rivetsData.loggedIn)
                    {
                        myClass.load_file(myClass.rivetsData.settings.DEFAULTIMG);
                    }
                }
                else if (arrayBuffer) {
                    var byteArray = new Uint8Array(arrayBuffer);
                    myClass.LoadEmulator(byteArray);
                }
                else{
                    this.rivetsData.lblError = 'Error downloading data. Try reloading browser.';
                    console.log('error downloading')
                    console.log(req);
                }
            }
            catch(error){
                console.log(error);
                toastr.error('Error Loading Save');
            }
        };

        req.send();
    }

    
    newRom(){
        location.reload();
    }

    onError(message){
        console.log('error triggered',event);
        if (
            !message.includes('user has exited the lock')
            )
        {
            this.rivetsData.lblError = message;
        }
    }

    //prevent dropdown from popping up from keyboard events
    dropdownKeyDown(e){
        e.preventDefault();
        e.stopPropagation();
    }

    fullscreen() {
        let el = document.getElementById('canvasDiv');

        if (el.webkitRequestFullScreen) {
            el.webkitRequestFullScreen();
        }
        else {
            el.mozRequestFullScreen();
        }
    }

    zoomIn(amount){
        this.canvasHeight += amount;
        localStorage.setItem('doswasmx-height', this.canvasHeight.toString());
        this.resizeCanvas();
        console.log('zoom in');
    }

    resizeCanvas(){
        let ratio = this.frameHeight / this.frameWidth;
        
        if (this.rivetsData.mobileMode)
            document.getElementById('canvasDiv').style.height = this.canvasWidth * ratio + 'px';
        else
            document.getElementById('canvasDiv').style.height = this.canvasHeight + 'px';
    }

    readFromLocalStorage(localStorageName, name){
        if (localStorage.getItem(localStorageName))
        {
            if (localStorage.getItem(localStorageName)=="true")
                this[name] = true;
            else if (localStorage.getItem(localStorageName)=="false")
                this[name] = false;
            else
                this[name] = localStorage.getItem(localStorageName);
        }
    }

    clearHardDrive(){

        let romToDelete = 'win95.disk';

        if (!window["indexedDB"]==undefined){
            console.log('indexedDB not available');
            return;
        }
        
        var request = indexedDB.open('DOSWASMXDB');
        request.onsuccess = function (ev) {
            var db = ev.target.result;
            var transaction = db.transaction("DOSWASMXSTATES", "readwrite");
            let request = transaction.objectStore("DOSWASMXSTATES").delete(romToDelete);

            try {
                // report that the data item has been deleted
                transaction.oncomplete = function() {
                    toastr.success('Hard Drive Deleted');
                    $('#settingsModal').modal('hide');
                    myClass.rivetsData.dblistDisks = [];
                };

            } catch (error) {
                toastr.error('Error Deleting Disk');
                console.log(error);
            }
        }

    }

    WriteConfigFile()
    {
        let configString = "";

        configString += "0\r\n"; // currently not used in c++
        configString += "0\r\n"; // currently not used in c++
        configString += "0\r\n"; // currently not used in c++
        configString += "0\r\n"; // currently not used in c++
        configString += "0\r\n"; // currently not used in c++
        configString += "0\r\n"; // currently not used in c++
        configString += this.rivetsData.mobileMode ? '1\r\n' : '0\r\n';

        FS.writeFile('config.txt',configString);
    }


    async unzipFile(arrayBuffer){

        const data = new Blob([ arrayBuffer ])
        let file = new File([data], 'win95.zip');

        document.getElementById('myProgress').innerHTML = 'Decompressing...';

        let zipReader = new zip.ZipReader(new zip.BlobReader(file));
        let entries = await zipReader.getEntries()
        let blob = await entries[0].getData(new zip.BlobWriter());
        let byteArray = new Uint8Array(await blob.arrayBuffer());
        document.getElementById('myProgress').innerHTML = 'Finished Decompressing';


        myClass.LoadEmulator(byteArray);
    }

    toggleOnscreenKeyboard(){
        Module._neil_toggle_onscreenkeyboard();
    }

    toggleFPS(){
        Module._neil_toggle_fps();
    }

    settingsModal(){

        this.rivetsData.ramTemp = this.ram;
        this.rivetsData.initialHardDriveTemp = this.initialHardDrive;
        this.rivetsData.dosVersionTemp = this.dosVersion;
        
        $("#settingsModal").modal();
    }

    settingsSubmit(){
        this.saveOptions();
        $('#settingsModal').modal('hide');
        toastr.info("Settings Saved");
    }

    async compressArrayBuffer(input) {
        //create the stream
        const cs = new CompressionStream("gzip");
        //create the writer
        const writer = cs.writable.getWriter();
        //write the buffer to the writer 
        writer.write(input);
        writer.close();
        //create the output 
        const output = [];
        const reader = cs.readable.getReader();
        let totalSize = 0;
        //go through each chunk and add it to the output
        while (true) {
          const { value, done } = await reader.read();
          if (done) break;
          output.push(value);
          totalSize += value.byteLength;
        }
        const concatenated = new Uint8Array(totalSize);
        let offset = 0;
        //finally build the compressed array and return it 
        for (const array of output) {
          concatenated.set(array, offset);
          offset += array.byteLength;
        }
        console.log('compressed', concatenated);

        return concatenated;
    }

    async decompressArrayBuffer(input) {
        //create the stream
        const ds = new DecompressionStream("gzip");
        //create the writer
        const writer = ds.writable.getWriter();
        //write the buffer to the writer thus decompressing it 
        writer.write(input);
        writer.close();
        //create the output
        const output = [];
        //create the reader
        const reader = ds.readable.getReader();
        let totalSize = 0;
        //go through each chunk and add it to the output
        while (true) {
         const { value, done } = await reader.read();
         if (done) break;
         output.push(value);
         totalSize += value.byteLength;
        }
        const concatenated = new Uint8Array(totalSize);
        let offset = 0;
        //finally build the compressed array and return it 
        for (const array of output) {
         concatenated.set(array, offset);
         offset += array.byteLength;
        }

        return concatenated;
    }

    importFiles(event){
        console.log('import files');

        if (!myClass.rivetsData.noCopyImport)
        {
            var rando = Math.floor(Math.random() * Math.floor(1000));
            myClass.importFolderName = 'Imp' + rando;
            Module.FS.mkdir('/' + myClass.importFolderName);
        }

        this.isSpecialHandler = false; 
        this.importedFileNames = [];
        let files = event.currentTarget.files;

        for(let i = 0; i < files.length; i++)
        {
            this.importedFileNames.push(files[i].name);
            let fileExtension = files[i].name.substr(files[i].name.lastIndexOf('.')).toLocaleLowerCase();
            if (this.specialFileHandlers.includes(fileExtension))
            {
                this.isSpecialHandler = true;
            }
        }

        myClass.processImportFiles(files, 0)
    }

    processImportFiles(files, index){
        var file = files[index];
        console.log('processing file ' + (index+1) + ' of ' + files.length, file);

        var reader = new FileReader();

        reader.onprogress = function (event) {
            let loaded = event.loaded;
            let total = event.total;

            loaded = Math.ceil(loaded / 1000000);
            total = Math.ceil(total / 1000000);

            // console.log('loaded: ' + event.loaded);
            myClass.rivetsData.importStatus = '(' + (index+1) + ' of ' + files.length + ') ' +
                file.name + ' ' + loaded + 'MB / ' + total + 'MB';
        };
        reader.onload = function (e) {
            var byteArray = new Uint8Array(this.result);

            if (myClass.rivetsData.noCopyImport || myClass.isSpecialHandler || myClass.rivetsData.changeFloppy || myClass.rivetsData.loadFloppy)
            {
                Module.FS.writeFile('/' + file.name, byteArray);
            }
            else
            {
                Module.FS.writeFile('/' + myClass.importFolderName + '/' + file.name, byteArray);
            }

            if ( (index+1)<files.length)
            {
                myClass.processImportFiles(files, index + 1);
            }
            else
            {
                $('#importModal').modal('hide');
                if (myClass.rivetsData.noCopyImport)
                {
                    Module._neil_exit_to_dos();
                }
                else if (myClass.rivetsData.changeFloppy)
                {
                    let filename = myClass.importedFileNames[0];
                    toastr.info('changing floppy ' + filename);
                    myClass.changeFloppyDisk(filename);
                }
                else if (myClass.rivetsData.loadFloppy)
                {
                    let filename = myClass.importedFileNames[0];
                    toastr.info('loading floppy ' + filename);
                    myClass.loadFloppyDisk(filename);
                }
                else if (myClass.rivetsData.changeCD)
                {
                    for(let i = 0; i < myClass.importedFileNames.length; i++)
                    {
                        let filename = myClass.importedFileNames[i];
                        if (filename.toLocaleLowerCase().endsWith('.iso') ||
                        filename.toLocaleLowerCase().endsWith('.cue'))
                        {
                            toastr.info('changing to ' + filename);
                            myClass.changeIso(filename);
                        }
                    }
                }
                else
                {
                    let importCommands = 
                        "mount e .\n" +
                        "xcopy e:\\" + myClass.importFolderName +
                        "\\*.* c:" + myClass.importFolderName  + " /I /E\n" +
                        "mount -u e\n" +
                        "boot c:\n";

                    if (myClass.isSpecialHandler)
                    {
                        importCommands = '';

                        for(let i = 0; i < myClass.importedFileNames.length; i++)
                        {
                            let filename = myClass.importedFileNames[i];
                            if (filename.toLocaleLowerCase().endsWith('.zip') ||
                                filename.toLocaleLowerCase().endsWith('.7z'))
                            {
                                //long folder names break with xcopy
                                let importFolder = myClass.sanitizeName(filename);

                                importCommands += 'mount e \"' + filename +
                                    "\"\nxcopy e:\ c:\\" + importFolder + 
                                    " /i /e\n" +
                                    'mount -u e\n';
                                myClass.winNotFoundCommands = 'cd ' + importFolder + '\n';
                            }
                            if (filename.toLocaleLowerCase().endsWith('.iso'))
                            {
                                importCommands += 
                                    'mount -u d\n' + //unmount existing iso if there is one
                                    'imgmount d \"' + filename + '\"\n'; //mount new iso
                                myClass.winNotFoundCommands = 'd:\n';
                            }
                            if (filename.toLocaleLowerCase().endsWith('.cue'))
                            {
                                importCommands += 
                                    'mount -u d\n' + //unmount existing iso if there is one
                                    'imgmount d \"' + filename + '\"\n'; //mount new iso
                                myClass.winNotFoundCommands = 'd:\n';
                            }
                            if (filename.toLocaleLowerCase().endsWith('.img'))
                            {
                                importCommands += 
                                    'mount -u c\n' + //unmount existing img if there is one
                                    'imgmount c \"' + filename + '\"\n'; //mount new iso
                            }
                        }

                        importCommands += 
                            'boot c:\n'; //boot windows
                    }

                    myClass.updateAutoexecAdditional(importCommands);
                    Module._neil_exit_to_dos();
                }
            }

        }
        reader.readAsArrayBuffer(file);
    }

    exitToDos(){
        Module._neil_exit_to_dos();
    }

    cacheIsoAndBaseImage(){

        if (!this.baseImageSaved)
        {
            //pause emulator
            Module._neil_toggle_pause();
            this.saveToDatabase(this.baseHardDrive, SaveTypes.BaseImage);
            return;
        }

        if (!this.isoSaved)
        {
            try
            {
                let bytes = Module.FS.readFile('/' + this.base_name + ".iso");
                this.saveToDatabase(bytes, SaveTypes.ISO);
                return;
            }
            catch(error){
                console.log('no iso found');
                //this means we did not have an iso                
            }
        }

        Module._neil_toggle_pause();
        
        //reset variables
        this.baseImageSaved = false;
        this.isoSaved = false;
    }

    convertCSharpDateTime(initialDate) {
        let dateString = initialDate;
        dateString = dateString.substring(0, dateString.indexOf('T'));
        let timeString = initialDate.substr(initialDate.indexOf("T") + 1);
        let dateComponents = dateString.split('-');
        let timeComponents = timeString.split(':');
        let myDate = null;

        myDate = new Date(parseInt(dateComponents[0]), parseInt(dateComponents[1]) - 1, parseInt(dateComponents[2]),
            parseInt(timeComponents[0]), parseInt(timeComponents[1]), parseInt(timeComponents[2]));
        return myDate;
    }

    HandleMessage(name, props) 
	{
        // console.log('handlemessage', name, props)
		if (name=='neil-resolution-changed')
		{
            console.log('ems: received neil-resolution-changed', props)
			this.frameWidth = props.width;
			this.frameHeight = props.height;
			// this.rgbSource = new Uint8Array(this.frameWidth * this.frameHeight * 3); 
			this.rgbaDestination = new Uint8ClampedArray(this.frameWidth * this.frameHeight * 4); 
			this.canvas.width = this.frameWidth;
			this.canvas.height = this.frameHeight;

            if (this.rivetsData.mobileMode)
            {
                this.resizeCanvas();
            }
			return;
		}
		if (name=='neil-update-frame')
		{
            let rgbSource = new Uint8Array(
                Module.HEAPU8.buffer,props.pointer, this.frameWidth * this.frameHeight * 4);

			myClass.updateCanvas(rgbSource);
			return;
		}
		// console.log(name, props);
	}

    Run()
	{
        //create some directories we will need
        Module.FS.mkdir('/uploaded');
        Module.FS.mkdir('/res');
        Module.FS.mkdir('/save');

        //canvas capture event
        if (!this.rivetsData.mobileMode)
        {
            document.getElementById('canvas').addEventListener("click", this.canvasClick.bind(this));
        }
	}

    sleepHandler(e) {
        const data = e.data;
        if (data?.name === "ws-sync-sleep" && data.props.sessionId === "123") {
			postMessage({ name: "wc-sync-sleep", props: data.props }, "*");
        }
    };

    printError(text)
	{
		console.log(text);
	}

    updateCanvas(rgbSource)
	{

        //this would work too - if not for the FPS counter
        // myClass.ctx.putImageData(new ImageData(new Uint8ClampedArray(rgbSource), this.frameWidth, this.frameHeight), 0, 0);

        let destinationCounter = 0;
        for (let y = 0; y < this.frameHeight; y++) 
        {
            for (let x = 0; x < this.frameWidth; x++) 
            {
                this.rgbaDestination[destinationCounter * 4 + 0] = rgbSource[destinationCounter * 4 + 0];
                this.rgbaDestination[destinationCounter * 4 + 1] = rgbSource[destinationCounter * 4 + 1];
                this.rgbaDestination[destinationCounter * 4 + 2] = rgbSource[destinationCounter * 4 + 2];
                this.rgbaDestination[destinationCounter * 4 + 3] = 255;
                destinationCounter++;
            }
        }

        myClass.ctx.putImageData(new ImageData(this.rgbaDestination, this.frameWidth, this.frameHeight), 0, 0);
	}

	canvasClick(){
        let isPointerCurrentlyLocked = document.pointerLockElement;
        if (!isPointerCurrentlyLocked)
            this.captureMouse();
    }

    captureMouse(){
        let canvas = document.getElementById('canvas');

        //mouse capture
        canvas.requestPointerLock = canvas.requestPointerLock ||
        canvas.mozRequestPointerLock;

        canvas.requestPointerLock()
    }

    setupInputController(){
        this.rivetsData.inputController = new InputController();
    }
}


let myClass = new MyClass();
window["myApp"] = myClass; //so that I can reference from EM_ASM

let rando2 = Math.floor(Math.random() * 100000);
let script2 = document.createElement('script');
script2.src = 'input_controller.js?v=' + rando2;
document.getElementsByTagName('head')[0].appendChild(script2);

window.onerror = function(message) {
    console.log('window.onerror',message);
    myClass.onError(message);
}

window.onunhandledrejection = function(error) {
    console.log('window.onunhandledrejection',error);
    myClass.onError(error.reason.message);
}
  
window["Module"] = {
    onRuntimeInitialized: myClass.initModule,
    print: (text) => myClass.processPrintStatement(text),
}

window.addEventListener("message", myClass.sleepHandler, { passive: true });
