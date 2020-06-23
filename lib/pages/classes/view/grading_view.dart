import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:quiver/iterables.dart';
import 'package:validators/validators.dart';

class GradingChart extends StatefulWidget {
  final Map<String, double> grading;
  final bool withHeader;

  const GradingChart({Key key, this.grading, this.withHeader = true})
      : super(key: key);

  @override
  _GradingChartState createState() => _GradingChartState();
}

class _GradingChartState extends State<GradingChart> {
  Map<String, double> get gradingDataMap => widget.grading?.map(
      (name, value) => MapEntry(name + '\n' + value.toString() + 'p', value));

  @override
  Widget build(BuildContext context) {
    ClassProvider classProvider = Provider.of<ClassProvider>(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            if (widget.withHeader)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).sectionGrading,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider.value(
                        value: classProvider,
                        child: GradingView(
                          grading: widget.grading,
                        ),
                      ),
                    )),
                  ),
                ],
              ),
            gradingDataMap != null
                ? PieChart(
                    dataMap: gradingDataMap,
                    legendPosition: LegendPosition.left,
                    legendStyle: Theme.of(context).textTheme.subtitle2,
                    chartValueStyle: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 12),
                    decimalPlaces: 1,
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text(S.of(context).labelUnknown)),
                  ),
          ],
        ),
      ),
    );
  }
}

class GradingView extends StatefulWidget {
  final Map<String, double> grading;

  const GradingView({Key key, this.grading}) : super(key: key);

  @override
  _GradingViewState createState() => _GradingViewState();
}

class _GradingViewState extends State<GradingView> {
  Map<String, double> grading;
  final formKey = GlobalKey<FormState>();
  List<TextEditingController> nameContollers = [];
  List<TextEditingController> valueControllers = [];
  TextEditingController totalController = TextEditingController(text: '0.0');

  @override
  void initState() {
    super.initState();
    grading = widget.grading;
    widget.grading?.forEach((name, value) {
      nameContollers.add(TextEditingController(text: name));
      valueControllers.add(TextEditingController(text: value.toString()));
    });
    nameContollers.add(TextEditingController());
    valueControllers.add(TextEditingController());
    updateTotal();
  }

  void updateTotal() async {
    double total = 0;
    valueControllers.forEach((controller) {
      if (controller.text != '') {
        total += double.parse(controller.text);
      }
    });
    totalController.text = total.toString();
  }

  void updateChart() async {
    grading = {};
    nameContollers.asMap().forEach((i, nameController) {
      if (nameController.text != '') {
        grading[nameController.text] = double.parse(valueControllers[i].text);
      }
    });
    setState(() {});
  }

  void updateTextFields() async {
    for (var i in range(nameContollers.length - 1)) {
      if (nameContollers[i].text == '' &&
          (valueControllers[i].text == '' ||
              double.parse(valueControllers[i].text) == 0)) {
        nameContollers.removeAt(i);
        valueControllers.removeAt(i);
      }
    }

    if (nameContollers.last.text != '' &&
        valueControllers.last.text != '' &&
        double.parse(valueControllers.last.text) != 0) {
      nameContollers.add(TextEditingController());
      valueControllers.add(TextEditingController());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: S.of(context).actionEditGrading,
      actions: [
        AppScaffoldAction(
            text: S.of(context).buttonSave,
            onPressed: () {
              if (formKey.currentState.validate()) {
//                widget.onSave(Shortcut(
//                  name: nameContollers.text,
//                  link: valueControllers.text,
//                  type: selectedType,
//                  ownerUid:
//                  Provider.of<AuthProvider>(context, listen: false).uid,
//                ));
                Navigator.of(context).pop();
              }
            })
      ],
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GradingChart(
              grading: grading,
              withHeader: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                S.of(context).labelEvaluation,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                S.of(context).labelPoints,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      )
                    ] +
                    zip([nameContollers, valueControllers]).map((controllers) {
                      var nameContoller = controllers[0];
                      var valueController = controllers[1];

                      return Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: nameContoller,
                              decoration: InputDecoration(
                                hintText: S.of(context).hintEvaluation,
                                prefixIcon: Icon(Icons.label),
                              ),
                              onChanged: (_) {
                                updateChart();
                                updateTextFields();
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: valueController,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              decoration: InputDecoration(
                                hintText: S.of(context).hintPoints,
                              ),
                              onFieldSubmitted: (_) {
                                updateTotal();
                                updateChart();
                              },
                              validator: (value) {
                                if (!isURL(value, requireProtocol: true)) {
                                  return S.of(context).warningInvalidURL;
                                }
                                return null;
                              },
                              onChanged: (_) {
                                updateChart();
                                updateTotal();
                                updateTextFields();
                              },
                            ),
                          )
                        ],
                      );
                    }).toList() +
                    [
                      Divider(),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Text(
                                'Total:',
                                textAlign: TextAlign.right,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: totalController,
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                    ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
