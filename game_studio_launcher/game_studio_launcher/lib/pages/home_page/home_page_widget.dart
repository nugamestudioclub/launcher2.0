import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';
import 'package:game_studio_launcher/gameItem.dart';
import 'package:game_studio_launcher/pages/home_page/importer.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'cardOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(1000.0, 0.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
  };

  List<GameItem> gameData = <GameItem>[];
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
    slowLoadXml();
  }

  void slowLoadXml() async {
    List<GameItem> gData = parseXmlData(await readXmLFile());
    setState(() {
      gameData = gData;
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    List<Widget> gameCards = <Widget>[];
    List<Widget> gameSummaries = <Widget>[];

    print(gameSummaries.length);
    for (GameItem data in gameData) {
      gameSummaries.add(
        Align(
          alignment: AlignmentDirectional(0.00, -1.00),
          child: FFButtonWidget(
            onPressed: () {
              setState(() => data.isVisible = !data.isVisible);
            },
            text: data.name,
            options: FFButtonOptions(
              width: 200.0,
              height: 40.0,
              padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: data.isVisible
                  ? FlutterFlowTheme.of(context).accent1
                  : FlutterFlowTheme.of(context).accent4,
              textStyle: FlutterFlowTheme.of(context).titleSmall,
              elevation: 3.0,
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      );
      if (data.isVisible) {
        gameCards.add(GestureDetector(
          onTap: () {
            launchApp(data.path, context);
          },
          child: Align(
            alignment: AlignmentDirectional(-1.00, -1.00),
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: FlutterFlowTheme.of(context).secondaryBackground,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                child: ListView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          data.imagePath,
                          width: 200.0,
                          height: 163.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                      child: Text(
                        data.name,
                        style: FlutterFlowTheme.of(context).titleLarge,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                      child: Text(
                        data.description,
                        style: FlutterFlowTheme.of(context).bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ).animateOnPageLoad(animationsMap['cardOnPageLoadAnimation']!),
          ),
        ));
      }
    }
    bool allVisible = true;
    for (GameItem data in gameData) {
      allVisible = allVisible && data.isVisible;
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).accent1,
          automaticallyImplyLeading: false,
          title: Text(
            'NU Game Studio Club Launcher',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 30.0,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 0.9,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 100.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 200.0,
                              height: MediaQuery.sizeOf(context).height * 0.9,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).accent4,
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 50.0, 0.0, 0.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.00, 1.00),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 10.0),
                                          child: Text(
                                            'Select Games',
                                            style: FlutterFlowTheme.of(context)
                                                .displaySmall
                                                .override(
                                                  fontFamily: 'Outfit',
                                                  fontSize: 30.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 200.0,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.8,
                                        decoration: BoxDecoration(),
                                        child: ListView(
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.vertical,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.00, -1.00),
                                              child: FFButtonWidget(
                                                onPressed: () {
                                                  for (GameItem data
                                                      in gameData) {
                                                    setState(() =>
                                                        data.isVisible =
                                                            !allVisible);
                                                  }
                                                },
                                                text: allVisible
                                                    ? 'Deselect All'
                                                    : 'Select All',
                                                options: FFButtonOptions(
                                                  width: 200.0,
                                                  height: 40.0,
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          24.0, 0.0, 24.0, 0.0),
                                                  iconPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0.0, 0.0,
                                                              0.0, 0.0),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .accent1,
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall,
                                                  elevation: 3.0,
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                            ),
                                            ...gameSummaries,
                                          ].divide(SizedBox(height: 5.0)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.83,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.8,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0.00, 0.00),
                                    child: GridView(
                                      padding: EdgeInsets.zero,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 10.0,
                                        childAspectRatio: 1.0,
                                      ),
                                      scrollDirection: Axis.vertical,
                                      children: [
                                        ...gameCards,
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
