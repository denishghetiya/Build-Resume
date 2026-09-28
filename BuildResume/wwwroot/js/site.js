$(document).ready(function () {

    $("#createResumeForm").submit(function (e) {
        e.preventDefault();
        var per = true;
        var currentDate = new Date().toISOString().slice(0, 10);
        if (!$(this).valid()) {
            return false;   }
        $('#errors').empty();
        var html = '<div>';
        $('#partialViewContainer').find('.errorexpone').remove(); 
        if ($('.partial-item').length == 0) {
            html += 'At least one Experience is required!<br/>';
            per = false;
            $('#partialViewContainer').append('<div class="errorexpone" style="color:red">At least one Experience is required !!!</div>');
        }
        $('.partial-item').each(function (exp) {
            var expDiv = $(this);
            var startDateE = expDiv.find('input[name$=".StartDate"]').val();
            var endDateE = expDiv.find('input[name$=".EndDate"]').val();
            var ehtml = '<div class="errorexponly" style="color:red">';
            if(Date.parse(startDateE) >= Date.parse(endDateE))
            {
                html += 'Experience '+(exp+1)+': EndDate Must be greater than StartDate !!!<br/>';
                per = false;
                ehtml += 'EndDate Must be greater than StartDate !!!<br/>';
            }
            if((Date.parse(startDateE) >= Date.parse(currentDate)) || (Date.parse(endDateE) > Date.parse(currentDate)))
            {
                html += 'Experience '+(exp+1)+': StartDate and EndDate Must be less than CurrentDate !!!<br/>';
                per = false;
                ehtml += 'StartDate and EndDate Must be less than CurrentDate !!!<br/>';
            }
            var projectCount = expDiv.find('.project-container .partial-project').length;
            if (projectCount == 0) {
                html += 'Experience ' + (exp + 1) + ': At least one Project is required!<br/>';
                per = false;
                //expDiv.find('.errorexp').append('<div class="errorexponly" style="color:red">At least one Project is required !!!</div>');
                ehtml += 'At least one Project is required !!!';
            }
            ehtml += '</div>';
            expDiv.find('.errorexponly').remove(); 
            expDiv.find('.errorexp').append(ehtml);
            expDiv.find('.project-container .partial-project').each(function (proj) {
                var projDiv = $(this);
                var startDateP = projDiv.find('input[name$=".StartDate"]').val();
                var endDateP = projDiv.find('input[name$=".EndDate"]').val();
                var phtml = '<div class="errorprojonly" style="color:red">';
                
                if(Date.parse(startDateP) >= Date.parse(endDateP))
                {
                    html += 'Project '+(proj+1)+' of Experience '+(exp+1)+': EndDate Must be greater than StartDate !!!<br/>';
                    per = false;
                    phtml += 'EndDate Must be greater than StartDate !!!<br/>';
                }
                if((Date.parse(startDateP) > Date.parse(currentDate)) || (Date.parse(endDateP) > Date.parse(currentDate)))
                {
                    html += 'Project '+(proj+1)+'  of Experience '+(exp+1)+': StartDate and EndDate Must be less than CurrentDate !!!<br/>';
                    per = false;
                    phtml += 'StartDate and EndDate Must be less than CurrentDate !!!<br/>';
                }
                if(Date.parse(startDateP)<Date.parse(startDateE)||Date.parse(startDateP)>Date.parse(endDateE)
                ||Date.parse(endDateP)<Date.parse(startDateE)||Date.parse(endDateP)>Date.parse(endDateE))
                {
                    html += 'Project '+(proj+1)+' of Experience '+(exp+1)+': StartDate and EndDate Must be in range of Experience '+(exp+1)+' Duration !!!<br/>';
                    per = false;
                    phtml += 'StartDate and EndDate Must be in range of Experience Duration !!!<br/>';
                }
                phtml += '</div>';
                projDiv.find('.errorproj .errorprojonly').remove();
                projDiv.find('.errorproj').append(phtml);

                var notanycheck = false;
                var plhtml = '<div class="errorplonly" style="color:red">';
                projDiv.find('.projectlanguage').each(function (){
                    var projlangg = $(this);
                    var pl = projlangg.find('input[name$=".IsChecked"]').is(":checked");
                    if(pl==true){
                        notanycheck = true;
                    }
                });
                if(notanycheck == false){
                    per = false;
                    plhtml += 'Select anyone Language !!!<br/>';
                }
                plhtml += '</div>';
                projDiv.find('.errorpl .errorplonly').remove();
                projDiv.find('.errorpl').append(plhtml);
            });
            
        });
        html += '</div><hr/>';
        //$('#errors').append(html);
        if(per == true){
        var formData = $(this);
            $.ajax({
                url: "/Resume/CreateResume", 
                type: "POST",
                data: formData.serialize(),
                success: function (response) {
                    if (response.success == true) {
                        alert(response.message);
                        window.location.href = "/Resume/ResumeList"; 
                    }
                    else{
                        alert(response.message);
                    }
                },
                error: function (res) {
                    alert("Something went wrong: " + res.responseText);
                }
            });
        }
    });

    $('#addPartialButton').on('click', function () {
        $.ajax({
            url: "/Resume/GetEmptyPartial", 
            type: "GET",
            success: function (data) {
                $('#partialViewContainer').append(data);
                var form = $('#createResumeForm');
                form.removeData("validator");
                //form.removeData("unobtrusiveValidation");
                $.validator.unobtrusive.parse(form);
                $('#summaryContainer').empty();
                var tempval = $('#searchTemplate').val();
                templateSummary(tempval);
                Summary();
            },
            error: function (res) {
                alert("Something went wrong: " + res.responseText);
            }
        });
    });

    $('#partialViewContainer').on('click', '#removeExperience', function (e) {
            e.preventDefault();

            var projectDiv = $(this).closest('.partial-item');
            var indexVal = projectDiv.prev('input[type=hidden][name="Experience.index"]').val();

            projectDiv.remove();
            $('input[type=hidden][name="Experience.index"][value="' + indexVal + '"]').remove();
            $('#summaryContainer').empty();
                var tempval = $('#searchTemplate').val();
                templateSummary(tempval);
            Summary();
    });

    $('#partialViewContainer').on('click', '.add-project', function () {
        
        var experienceContainer = $(this).closest('.partial-item');
        var parentPrefix = $(this).data("prefix");
        $.ajax({
            url: "/Resume/GetEmptyPartialProject?parentPrefix="+parentPrefix, 
            type: "GET",
            success: function (data) {
                experienceContainer.find('.project-container').append(data);
                var form = $('#createResumeForm');
                form.removeData("validator");
                //form.removeData("unobtrusiveValidation");
                $.validator.unobtrusive.parse(form);
                $('#summaryContainer').empty();
                var tempval = $('#searchTemplate').val();
                templateSummary(tempval);
                Summary();
            },
            error: function (res) {
                console.log("Something went wrong: " + res.responseText);
                alert("Something went wrong: " + res.responseText);
            }
        });
    });
    
    $('#partialViewContainer').on('click', '.remove-project', function (e) {
            e.preventDefault();
            
            var projectDiv = $(this).closest('.partial-project');
            var indexVal = projectDiv.prev('input[type=hidden][name$=".Projects.index"]').val();

            projectDiv.remove();
            $('input[type=hidden][name$=".Projects.index"][value="' + indexVal + '"]').remove();
            $('#summaryContainer').empty();
                var tempval = $('#searchTemplate').val();
                templateSummary(tempval);
            Summary();
    });

    $('#resumeList').DataTable({
        searching: false,
        order: [],
        processing: true,
        serverSide: true,
        autoWidth: false,
        lengthMenu: [[10, 25, 50, 100], [10, 25, 50, 100]],
        ajax: {
            url: "/Resume/ResumeList",
            type: "POST",
            contentType: "application/json",
            data: function (d) {
                return JSON.stringify({
                    draw: d.draw,
                    start: d.start,
                    length: d.length,
                    //search: null,
                    columns: d.columns.map((col, index) => ({
                        field: col.data,
                        isSortable: col.orderable,
                        sort: d.order.find(o => o.column === index)
                            ? { direction: d.order.find(o => o.column === index).dir === "asc" ? 0 : 1 }
                            : null
                    })),
                    filters: {
                        field1: $("#searchName").val(),
                        field2: $("#searchPhone").val(),
                        field3: $("#searchEmail").val(),
                        field4: $("#searchProject").val() 
                    }
                });
            }
        },
        columns: [
            { title: "User Id", data: "userId", visible: false, searchable: false },
            { title: "Full Name", data: "fullName", searchable: true },
            { title: "Phone Number", data: "phoneNumber" , searchable: true},
            { title: "Email", data: "email" , searchable: true},
            { title: "Template", data: "searchTemplate" , visible: false, searchable: false},
            { title: "Experience", data: "experience" , searchable: false},
            { title: "Projects", data: "projects" ,orderable: false, searchable: true},
            {
                title: "Action",
                data: "userId",
                orderable: false,
                searchable: false,
                width: "10%",
                render: function (data) {
                    return `
                        <div class="btn-group" role="group">
                            <button type="button" class="btn btn-sm btn-primary dropdown-toggle" data-bs-toggle="dropdown">Action</button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item btnedituser text-primary" href="/Resume/CreateResume?userId=${data}" ><i class="fa fa-edit"></i>&nbsp;Edit</a></li>
                                <li><a class="dropdown-item btndeleteuser text-danger" style="cursor: pointer;" onclick="deleteResume(${data})" ><i class="fa fa-trash"></i>&nbsp;Delete</a></li>
                                <li><a class="dropdown-item btnsendmail text-success" style="cursor: pointer;" onclick="sendmail(${data})" ><i class="fa fa-mail"></i>&nbsp;Send Mail</a></li>
                            </ul>
                        </div>`;
                }
            }
        ]
    });
    
    $('#searchProject').select2({
        placeholder: "-- Select Project --",
        //allowClear: true,
        width: '100%',         
        theme: 'bootstrap-5'   
    });

    Summary();
    
    $('#createResumeForm').on('input', function() {

        $(this).find(':input').on('input', function() {
        
        var d = $(this).attr('name');
        var e = $(this).val();
        $('lable[name="'+d+'"]').text(e);});

        Summary();
    });
    var tempvall = $('#searchTemplate').val();
    if(tempvall){ templateSummary(tempvall); }
    $('#searchTemplate').on('change', function(){

        var tempval = $(this).val();
        templateSummary(tempval);
        //templateSummary();
    });

    $('#convertingtopdf').click(function () {
        
        CreatePDFfromHTML();
    });

});

function sendmail(userId) {
    $.ajax({
        url: "/Resume/GetData?userId=" + userId,
        type: "GET",
        success: function (response) {
            if (response.success) {
                var templateName = response.template;
                var resumeModel = response.data;
                var emaill = response.email;
                var formData = $.param(resumeModel);
                $.ajax({
                    url: "/Resume/GetTemplate?template=" + templateName,
                    type: "POST",
                    data: formData, 
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                    success: function (htmlResponse) {
                        
                        $.ajax({
                            url: "/Resume/SendMail",
                            type: "POST",
                            data: { data: htmlResponse,email: emaill },
                            success: function (mailResponse) {
                                alert("Mail sent successfully!");
                            },
                            error: function (res2) {
                                alert("Mail send failed: " + res2.responseText);
                            }
                        });
                    },
                    error: function (res1) {
                        alert("Template render failed: " + res1.responseText);
                    }
                });
            } else {
                alert("Failed to load data: " + response.message);
            }
        },
        error: function (res) {
            alert("Something went wrong: " + res.responseText);
        }
    });
}


function templateSummary(tempval) {
//function templateSummary() {
    //var tempval = $('#searchTemplate').val();
    var formData = $('#createResumeForm');
    $.ajax({
        url: "/Resume/GetTemplate?template="+tempval, 
        type: "POST",
        data: formData.serialize(),
        success: function (data) {
            
            //$('#template').append(data);
            $('#summaryContainer').empty();
            $('#summaryContainer').append(data);
            
            //Summary();
            changenamesumrylable();
        },
        error: function (res) {
            console.log("Something went wrong: " + res.responseText);
            alert("Something went wrong: " + res.responseText);
        }
    });
}

function CreatePDFfromHTML() {
    
    var element = document.getElementById('summaryContainer');
    var opt = {
      margin:       1,
      filename:     'Resume.pdf',
      image:        { type: 'jpeg', quality: 0.98 },
      html2canvas:  { scale: 2 },
      jsPDF:        { unit: 'in', format: 'letter', orientation: 'portrait' }
    };
    html2pdf().set(opt).from(element).save();
    //html2pdf(element, opt);
}
function Summary() {

        var firstname = $('#FirstName').val();
        var lastname = $('#LastName').val();
        var phonenumber = $('#PhoneNumber').val();
        var email = $('#Email').val();
        var nfirstname = $('#FirstName').attr('name');
        var nlastname = $('#LastName').attr('name');
        var nphonenumber = $('#PhoneNumber').attr('name');
        var nemail = $('#Email').attr('name');

        var expHtml = '<div class="usersummary" style="margin-left:15px;">' +
                '<strong>Summary : </strong><br/>' +
                'FirstName: <lable name="'+nfirstname+'">' + firstname + '</lable><br/>' +
                'LastName: <lable name="'+nlastname+'">' + lastname + '</lable><br/>' +
                'PhoneNumber: <lable name="'+nphonenumber+'">' + phonenumber + '</lable><br/>' +
                'Email: <lable name="'+nemail+'">' + email + '</lable><br/>' ;

        //$('#template').empty();
        var previousExpEndDate = new Date();
        var currentDate = new Date().toISOString().slice(0, 10);
        var expCount = $('.partial-item').length;
            if (expCount == 0) {
                $('#addPartialButton').prop('disabled',false);
            }
        $('.partial-item').each(function (exp) {
            debugger
            var expDiv = $(this);
            var companyName = expDiv.find('input[name$=".CompanyName"]').val();
            var role = expDiv.find('input[name$=".Role"]').val();
            var startDate = expDiv.find('input[name$=".StartDate"]').val();
            var endDate = expDiv.find('input[name$=".EndDate"]').val();
            var experience = expDiv.find('input[name$=".Experience"]').val();

            var ncompanyName = expDiv.find('input[name$=".CompanyName"]').attr('name');
            var nrole = expDiv.find('input[name$=".Role"]').attr('name');
            var nstartDate = expDiv.find('input[name$=".StartDate"]').attr('name');
            var nendDate = expDiv.find('input[name$=".EndDate"]').attr('name');
            var nexperience = expDiv.find('input[name$=".Experience"]').attr('name');

            if(currentDate == endDate)
                {
                    $('#addPartialButton').prop('disabled', true);
                } else {
                    $('#addPartialButton').prop('disabled',false);
                }
            if (exp > 0) {  
                var prevExpEnd = new Date(previousExpEndDate);
                expDiv.find('input[name$=".StartDate"]').attr('min', prevExpEnd.toISOString().split('T')[0]);
                expDiv.find('input[name$=".EndDate"]').attr('min', prevExpEnd.toISOString().split('T')[0]);
            }
            expDiv.find('input[name$=".EndDate"]').attr('min', startDate);

            if(endDate > startDate){
            var difdt = new Date(Date.parse(endDate) - Date.parse(startDate));
            var diff = (difdt.toISOString().slice(0, 4) - 1970) + "Y " + (difdt.getMonth()) + "M " + (difdt.getDate()) + "D";
            expDiv.find('input[name$=".Experience"]').val(diff);
            $('#summaryContainer').find('lable[name="'+nexperience+'"]').text(diff);
            } else {
            expDiv.find('input[name$=".Experience"]').val('');
            }
            previousExpEndDate = new Date(endDate); 
            previousExpEndDate.setDate(previousExpEndDate.getDate() + 1);
            expHtml += '<div class="expsummary" style="margin-left:15px;">' +
                '<strong>Experience : '+(exp+1)+' </strong><br/>' +
                'Company: <lable name="'+ncompanyName+'">' + companyName + '</lable><br/>' +
                'Role: <lable name="'+nrole+'">' + role + '</lable><br/>' +
                'StartDate: <lable name="'+nstartDate+'">' + startDate + '</lable><br/>' +
                'EndDate: <lable name="'+nendDate+'">' + endDate + '</lable><br/>' +
                'Experience: <lable name="'+nexperience+'">' + experience + '</lable><br/>' ;

                //'Company: ' + companyName + '<br/>' +
                //'Role: ' + role + '<br/>' +
                //'StartDate: ' + startDate + '<br/>' +
                //'EndDate: ' + endDate + '<br/>' +
                //'Experience: ' + diff + '<br/>' ;
                
            var projectCount = expDiv.find('.project-container .partial-project').length;
            if (projectCount == 0) {
                expDiv.find('.project-container :button[type="button"]').prop('disabled', false);
            }
            var previousProjectEndDate = new Date(startDate);
            expDiv.find('.project-container .partial-project').each(function (proj) {
                var projDiv = $(this);
                var projName = projDiv.find('input[name$=".ProjectName"]').val();
                var projRole = projDiv.find('input[name$=".Role"]').val();
                var projTech = projDiv.find('input[name$=".TechnologyNames"]').val();
                var projStart = projDiv.find('input[name$=".StartDate"]').val();
                var projEnd = projDiv.find('input[name$=".EndDate"]').val();

                var nprojName = projDiv.find('input[name$=".ProjectName"]').attr('name');
                var nprojRole = projDiv.find('input[name$=".Role"]').attr('name');
                var nprojTech = projDiv.find('input[name$=".TechnologyNames"]').attr('name');
                var nprojStart = projDiv.find('input[name$=".StartDate"]').attr('name');
                var nprojEnd = projDiv.find('input[name$=".EndDate"]').attr('name');

                if(previousProjectEndDate.toISOString().split('T')[0] == endDate || projEnd == endDate)
                {
                    expDiv.find('.project-container :button[type="button"]').prop('disabled', true);
                } else {
                    expDiv.find('.project-container :button[type="button"]').prop('disabled', false);
                }
                
                projDiv.find('input[name$=".StartDate"]').attr('min', startDate); 
                projDiv.find('input[name$=".StartDate"]').attr('max', endDate); 
                projDiv.find('input[name$=".EndDate"]').attr('min', projStart);
                projDiv.find('input[name$=".EndDate"]').attr('max', endDate);
                if (proj > 0) {  
                    var prevProjectEnd = new Date(previousProjectEndDate);
                    projDiv.find('input[name$=".StartDate"]').attr('min', prevProjectEnd.toISOString().split('T')[0]);
                }
                previousProjectEndDate = new Date(projEnd); 
                previousProjectEndDate.setDate(previousProjectEndDate.getDate() + 1);
                expHtml += '<div class="projsummary" style="margin-left:15px;">' +
                    '<strong>Project : '+(proj+1)+' </strong><br/>' +
                    'Project Name: <lable name="'+nprojName+'">' + projName + '</lable><br/>' +
                    'Role: <lable name="'+nprojRole+'">' + projRole + '</lable><br/>' +
                    'Tech: <lable name="'+nprojTech+'">' + projTech + '</lable><br/>' +
                    'Start: <lable name="'+nprojStart+'">' + projStart + '</lable><br/>' +
                    'End: <lable name="'+nprojEnd+'">' + projEnd + '</lable><br/>' +
                    '<strong>Project Language : </strong>';

                    //'Project Name: ' + projName + '<br/>' +
                    //'Role: ' + projRole + '<br/>' +
                    //'Tech: ' + projTech + '<br/>' +
                    //'Start: ' + projStart + '<br/>' +
                    //'End: ' + projEnd + '<br/>' +
                    //'<strong>Project Language : </strong>';

                var langSummary = projDiv.find('.projectlanguage').map(function (){
                    var projlangg = $(this);
                    var pln = projlangg.find('label').text();
                    var pl = projlangg.find('input[name$=".IsChecked"]').is(":checked");
                    if (pl) {
                        return pln;
                    }
                }).get().join(', ');
                $('#summaryContainer').find('lable[name="Experience['+exp+'].Project['+proj+'].ProjectLanguage"]').text('');
                $('#summaryContainer').find('lable[name="Experience['+exp+'].Project['+proj+'].ProjectLanguage"]').text(langSummary);

                expHtml += langSummary+'</div>';
            });
        
        });
            expHtml += '</div><hr/>';
            //$('#template').append(expHtml);
}

function changenamesumrylable(){
    var tempsumr = $('#summaryContainer');
    $('.partial-item').each(function (exp) {

        var expDiv = $(this);
        var ncompanyName = expDiv.find('input[name$=".CompanyName"]').attr('name');
        var nrole = expDiv.find('input[name$=".Role"]').attr('name');
        var nstartDate = expDiv.find('input[name$=".StartDate"]').attr('name');
        var nendDate = expDiv.find('input[name$=".EndDate"]').attr('name');
        var nexperience = expDiv.find('input[name$=".Experience"]').attr('name');

        tempsumr.find('lable[name="Experience['+exp+'].CompanyName"]').attr('name',ncompanyName);
        tempsumr.find('lable[name="Experience['+exp+'].Role"]').attr('name',nrole);
        tempsumr.find('lable[name="Experience['+exp+'].StartDate"]').attr('name',nstartDate);
        tempsumr.find('lable[name="Experience['+exp+'].EndDate"]').attr('name',nendDate);
        tempsumr.find('lable[name="Experience['+exp+'].Experience"]').attr('name',nexperience);

        expDiv.find('.project-container .partial-project').each(function (proj) {

            var projDiv = $(this);
            var nprojName = projDiv.find('input[name$=".ProjectName"]').attr('name');
            var nprojRole = projDiv.find('input[name$=".Role"]').attr('name');
            var nprojTech = projDiv.find('input[name$=".TechnologyNames"]').attr('name');
            var nprojStart = projDiv.find('input[name$=".StartDate"]').attr('name');
            var nprojEnd = projDiv.find('input[name$=".EndDate"]').attr('name');

            tempsumr.find('lable[name="Experience['+exp+'].Project['+proj+'].ProjectName"]').attr('name',nprojName);
            tempsumr.find('lable[name="Experience['+exp+'].Project['+proj+'].Role"]').attr('name',nprojRole);
            tempsumr.find('lable[name="Experience['+exp+'].Project['+proj+'].TechnologyNames"]').attr('name',nprojTech);
            tempsumr.find('lable[name="Experience['+exp+'].Project['+proj+'].StartDate"]').attr('name',nprojStart);
            tempsumr.find('lable[name="Experience['+exp+'].Project['+proj+'].EndDate"]').attr('name',nprojEnd);
        });
    });
}



function deleteResume(resumeId) {
    let text = "Are you sure want to delete Resume ?";
    if (confirm(text) == true) {
    window.location.href = "/Resume/DeleteResume?userId="+resumeId; 
    }
}

function FilterOrReset(type) {
    if (type === "apply") {
        $('#resumeList').DataTable().ajax.reload();
    } else {
        $("#searchName, #searchPhone, #searchEmail").val('');
        $("#searchProject option:selected").prop("selected", false);
        $(".select2-selection__rendered").empty();
        $('#resumeList').DataTable().ajax.reload();
    }
}