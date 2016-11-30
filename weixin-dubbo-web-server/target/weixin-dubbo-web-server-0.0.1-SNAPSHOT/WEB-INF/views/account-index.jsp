<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <title>index</title>
    <!-- Bootstrap -->
    <link href="/resources/scripts/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="/resources/styles/theme.css" rel="stylesheet">
    <!--icon css -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
    <!-- tree css -->
    <link rel="stylesheet" href="/resources/scripts/bootstrap-treeview/css/bootstrap-treeview.min.css">

    <!--dataTables css -->
    <link rel="stylesheet" href="/resources/scripts/dataTables/css/dataTables.bootstrap.min.css">

    <script src="/resources/scripts/jquery.min.js"></script>
    <script src="/resources/scripts/bootstrap/js/bootstrap.min.js"></script>
    <!-- tree js -->
    <script src="/resources/scripts/bootstrap-treeview/js/bootstrap-treeview.min.js"></script>

    <!--dataTables js -->
    <script src="/resources/scripts/dataTables/js/jquery.dataTables.min.js"></script>
    <script src="/resources/scripts/dataTables/js/dataTables.bootstrap.min.js"></script>


    <script src="/resources/scripts/plugin/handlebars-v3.0.1.js"></script>

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="/resources/scripts/bootstrap/js/html5shiv.min.js"></script>
    <script src="/resources/scripts/bootstrap/js/respond.min.js"></script>
    <![endif]-->

</head>
<body>
<div class="wrapper">

    <!-- 头部导航条 begin -->
	<jsp:include page="/weixin/commons/header" flush="true" />
    <!-- 头部导航条 end -->

    <!-- 左侧菜单栏 begin -->
    <jsp:include page="/weixin/commons/aside" flush="true" />
    <!-- 左侧菜单栏 end -->

    <!-- 右侧内容区 begin -->
    <div class="content-wrapper">
        <section class="container-fluid main-content">
            <!-- 树结构头部begin -->
            <div class="row">
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                    <div class="btn btn-group " role="group">
                        <button type="button" class="btn btn-primary" id="select-all">全选</button>
                        <button type="button" class="btn btn-primary" id="delete-select-all"> 全不选</button>
                        <button type="button" class="btn btn-primary" id="unselected">反选</button>
                        <button type="button" class="btn btn-primary" id="refresh">刷新</button>
                        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal" id="add-row">新建</button>
                        <button type="button" class="btn btn-primary" id="delete-selected-row">删除所选</button>
                    </div>
                </div>
            </div>
            <!-- 纯内容模板 begin -->
            <div class="row main-content-footer">
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                    <table id="example" class="table table-striped table-bordered">
                        <thead>
                        <tr>
                            <th style="width:15px"><input type="checkbox" id='checkAll'></th>
                            <th>姓名</th>
                            <th>地点</th>
                            <th>薪水</th>
                            <th>入职时间</th>
                            <th>办公地点</th>
                            <th>编号</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <!-- tbody是必须的 -->
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </section>
    </div>
    <!-- 右侧内容区 end -->
</div>


<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                        aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">新增</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <input type="text" class="form-control" id="name" placeholder="姓名">
                </div>
                <div class="form-group">
                    <input type="text" class="form-control" id="position" placeholder="位置">
                </div>
                <div class="form-group">
                    <input type="text" class="form-control" id="salary" placeholder="薪资">
                </div>
                <div class="form-group">
                    <input type="text" class="form-control" id="start_date" placeholder="时间"
                           data-date-format="yyyy/mm/dd">
                </div>
                <div class="form-group">
                    <input type="text" class="form-control" id="office" placeholder="工作地点">
                </div>
                <div class="form-group">
                    <input type="text" class="form-control" id="extn" placeholder="编号">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="save">保存</button>
            </div>
        </div>
    </div>
</div>
<!--定义操作列按钮模板-->
<script id="tpl" type="text/x-handlebars-template">
    {{#each func}}
    <button type="button" class="btn btn-{{this.type}} btn-sm" onclick="{{this.fn}}">{{this.name}}</button>
    {{/each}}
</script>

<script>
    var table;
    var editFlag = false;
    $(function () {
        var tpl = $("#tpl").html();
        //预编译模板
        var template = Handlebars.compile(tpl);

        //头部导航栏 菜单隐藏按钮
        $(".main-header .main-header-right .nav-menu-btn").click(function () {
            if ($(this).attr("data-type") == "on") {
                $(".wrapper").removeClass("sidebar-collapse");
                $(this).removeAttr("data-type");
                setTimeout(function () {
                    $(".main-sidebar > ul > li > a > span:last-of-type").show();
                    //重新添加折叠效果
                    $(".main-sidebar > ul > li > a:first-of-type").each(function () {
                        $(this).attr("data-toggle", "collapse");
                    })
                }, "150");
            } else {
                //隐藏左侧菜单的子菜单
                $('.main-sidebar .collapse').collapse('hide');
                //取消折叠效果
                $(".main-sidebar > ul > li > a:first-of-type").each(function () {
                    $(this).removeAttr("data-toggle");
                })
                $(".main-sidebar > ul > li > ul:first-of-type").each(function () {
                    $(this).css("height", "auto");
                })
                $(this).attr("data-type", "on");
                $(".wrapper").addClass("sidebar-collapse");
                $(".main-sidebar > ul > li > a > span:last-of-type").hide();
            }
        });

        //临时数据
        table = $('#example').DataTable({
            ajax: {
                url: "list.txt"
            },
            serverSide: true,
            searching: false, //取消搜索框
            columns: [
                {
                    "data": "id",
                    "createdCell": function (nTd, sData, oData, iRow, iCol) {
                        $(nTd).html("<input type='checkbox' name='checkItem' value='" + sData + "' />");
                    }
                },
                {"data": "name"},
                {"data": "position"},
                {"data": "salary"},
                {"data": "start_date"},
                {"data": "office"},
                {"data": "extn"},
                {"data": null}
            ],
            columnDefs: [
                {
                    targets: 7,
                    render: function (a, b, c, d) {
                        var context =
                        {
                            func: [
                                {"name": "修改", "fn": "edit(\'" + c.name + "\',\'" + c.position + "\',\'" + c.salary + "\',\'" + c.start_date + "\',\'" + c.office + "\',\'" + c.extn + "\')", "type": "primary"},
                                {"name": "删除", "fn": "del(this,\'" + c.name + "\')", "type": "danger"}
                            ]
                        };
                        var html = template(context);
                        return html;
                    }
                }

            ],
            "language": {
                "lengthMenu": "_MENU_ 条记录每页",
                "zeroRecords": "没有找到记录",
                "info": "第 _PAGE_ 页 ( 总共 _PAGES_ 页 )",
                "infoEmpty": "无记录",
                "infoFiltered": "(从 _MAX_ 条记录过滤)",
                "paginate": {
                    "previous": "上一页",
                    "next": "下一页"
                }
            }
        });
        $("#save").click(add);

        //checkbox全选
        $("#checkAll").on("click", function () {
            var isChecked = $(this).prop("checked");
            $("input[name='checkItem']").prop("checked", isChecked);
        });

       table.rows().on("click","input[name='checkItem']", function () {
           //取消全选的选中效果
           if(!$(this).is(":checked"))
               $("#checkAll").prop("checked", false);
        });

        //全选
        $("#select-all").click(function(){
            $("#checkAll").prop("checked", true);
            $("input[name='checkItem']").prop("checked", true);

        });
        //全不选
        $("#delete-select-all").click(function(){
            $("#checkAll").prop("checked", false);
            $("input[name='checkItem']").prop("checked", false);
        });

        //反选
        $("#unselected").click(function(){
            if($("#checkAll").is(":checked"))
                $("#checkAll").trigger("click");
            else if($("#example tbody input:checkbox:checked").size()){
                $("#example tbody input:checkbox").each(function () {
                    this.checked = !this.checked;
                });
            }
        });

        //删除所选
        $("#delete-selected-row").click(function(){
            $("#example tbody input:checkbox:checked").each(function () {
                $(this).parents('tr').remove();
            });
        });
    });

    /**
     * 清除
     */
    function clear() {
        $("#name").val("").attr("disabled", false);
        $("#position").val("");
        $("#salary").val("");
        $("#start_date").val("");
        $("#office").val("");
        $("#extn").val("");
        editFlag = false;
    }

    /**
     * 添加数据
     **/
    function add() {
        var addJson = {
            "name": $("#name").val(),
            "position": $("#position").val(),
            "salary": $("#salary").val(),
            "start_date": $("#start_date").val(),
            "office": $("#office").val(),
            "extn": $("#extn").val()
        };
        ajax(addJson);
    }

    /**
     *编辑方法
     **/
    function edit(name, position, salary, start_date, office, extn) {
        console.log(name);
        editFlag = true;
        $("#myModalLabel").text("修改");
        $("#name").val(name).attr("disabled", true);
        $("#position").val(position);
        $("#salary").val(salary);
        $("#start_date").val(start_date);
        $("#office").val(office);
        $("#extn").val(extn);
        $("#myModal").modal("show");
    }

    function ajax(obj) {
        //此处应该进行数据库数据插入操作
//        var url = "add.jsp";
//        if (editFlag) {
//            url = "/edit.jsp";
//        }
//        $.ajax({
//            url: url,
//            data: {
//                "name": obj.name,
//                "position": obj.position,
//                "salary": obj.salary,
//                "start_date": obj.start_date,
//                "office": obj.office,
//                "extn": obj.extn
//            }, success: function (data) {
//                table.ajax.reload();
//                $("#myModal").modal("hide");
//                $("#myModalLabel").text("新增");
//                clear();
//                console.log("结果" + data);
//            }
//        });


    }


    /**
     * 删除数据
     * @param name
     */
    function del(o,name) {
        //此处要进行数据库数据删除操作
//        $.ajax({
//            url: "/del.jsp",
//            data: {
//                "name": name
//            }, success: function (data) {
//                table.ajax.reload();
//                console.log("删除成功" + data);
//            }
//        });
        $(o).parents('tr').remove();
    }
</script>
</body>
</html>
