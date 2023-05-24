import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' show NumberFormat;
import 'package:sorsfuse/components/map/model.dart';
import 'package:sorsfuse/components/map/sample_view.dart';
import 'package:sorsfuse/global/global.dart' as GLOBAL;
import 'package:sorsfuse/config/config.dart' as CONFIG;
///Core theme import
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class WorldMap extends StatefulWidget {
  /// Creates the map widget with range color mapping
  final List<Map<String, dynamic>> data;
  final String title;
  final String unit;
  WorldMap({required this.data, required this.title, this.unit="users"});

  @override
  WorldMapState createState() => WorldMapState();
}

class WorldMapState extends State<WorldMap> {
  
  List<_CountryDensity> _worldLeadDensity=[];

  // The format which is used for formatting the tooltip text.
  final NumberFormat _numberFormat = NumberFormat('#.#');

  late MapShapeSource _mapSource;

  @override
  void initState() {
    super.initState();

    // Data source to the map.
    //
    // [countryName]: Field name in the .json file to identify the shape.
    // This is the name to be mapped with shapes in .json file.
    // This should be exactly same as the value of the [shapeDataField]
    // in the .json file
    //
    // [density]: On the basis of this value, color mapping color has been
    // applied to the shape.
    widget.data.forEach((value) {
      _worldLeadDensity.add(_CountryDensity(value['country'], value['density']));
    });

    _mapSource = MapShapeSource.asset(
      // Path of the GeoJSON file.
      'assets/map/world_map.json',
      // Field or group name in the .json file
      // to identify the shapes.
      //
      // Which is used to map the respective
      // shape to data source.
      //
      // On the basis of this value,
      // shape tooltip text is rendered.
      shapeDataField: 'name',
      // The number of data in your data source collection.
      //
      // The callback for the [primaryValueMapper]
      // will be called the number of times equal
      // to the [dataCount].
      // The value returned in the [primaryValueMapper]
      // should be exactly matched with the value of the
      // [shapeDataField] in the .json file. This is how
      // the mapping between the data source and the shapes
      // in the .json file is done.
      dataCount: _worldLeadDensity.length,
      primaryValueMapper: (int index) =>
      _worldLeadDensity[index].countryName,
      // Used for color mapping.
      //
      // The value of the [MapColorMapper.from]
      // and [MapColorMapper.to]
      // will be compared with the value returned in the
      // [shapeColorValueMapper] and the respective
      // [MapColorMapper.color] will be applied to the shape.
      shapeColorValueMapper: (int index) =>
      _worldLeadDensity[index].density,
      // Group and differentiate the shapes using the color
      // based on [MapColorMapper.from] and
      //[MapColorMapper.to] value.
      //
      // The value of the [MapColorMapper.from] and
      // [MapColorMapper.to] will be compared with the value
      // returned in the [shapeColorValueMapper] and
      // the respective [MapColorMapper.color] will be applied
      // to the shape.
      //
      // [MapColorMapper.text] which is used for the text of
      // legend item and [MapColorMapper.color] will be used for
      // the color of the legend icon respectively.
      shapeColorMappers: <MapColorMapper>[
        const MapColorMapper(
            from: 0,
            to: 100,
            color: Color.fromRGBO(255, 216, 100, 1),
            text: '{0},{100}'),
        const MapColorMapper(
            from: 100,
            to: 500,
            color: Color.fromRGBO(51, 102, 255, 1),
            text: '500'),
        const MapColorMapper(
            from: 500,
            to: 1000,
            color: Color.fromRGBO(0, 57, 230, 1),
            text: '1k'),
        const MapColorMapper(
            from: 1000,
            to: 5000,
            color: Color.fromRGBO(0, 45, 179, 1),
            text: '5k'),
        const MapColorMapper(
            from: 5000,
            to: 50000,
            color: Color.fromRGBO(0, 26, 102, 1),
            text: '50k'),
      ],
    );
  }

  @override
  void dispose() {
    _worldLeadDensity.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool scrollEnabled = constraints.maxHeight > 500;
          double height = scrollEnabled ? constraints.maxHeight : 500;
          if (MediaQuery.of(context).orientation == Orientation.landscape) {
            final double refHeight = height * 0.6;
            height = height > 600 ? (refHeight < 600 ? 600 : refHeight) : height;
          }
          return Center(
            child: SingleChildScrollView(
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: height,
                  child: _buildMapsWidget(scrollEnabled),
                )),
          );
        });
  }

  Widget _buildMapsWidget(bool scrollEnabled) {
    return Center(
        child: Padding(
          padding: scrollEnabled
              ? EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0,
              bottom: MediaQuery.of(context).size.height * 0,
              right: 10)
              : const EdgeInsets.only(right: 10, bottom: 15),
          child: SfMapsTheme(
            data: SfMapsThemeData(
              shapeHoverColor: CONFIG.secondaryColor,
            ),
            child: Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Align(
                      child: Text(widget.title,
                          style: Theme.of(context).textTheme.titleMedium))),
              Expanded(
                child: SfMaps(
                  layers: <MapLayer>[
                    MapShapeLayer(
                      loadingBuilder: (BuildContext context) {
                        return const SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                        );
                      },
                      source: _mapSource,
                      // Returns the custom tooltip for each shape.
                      shapeTooltipBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              _worldLeadDensity[index].countryName +
                                  ' : ' +
                                  _numberFormat.format(
                                      _worldLeadDensity[index].density) +
                                  ' '+widget.unit,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                  color:
                                  Theme.of(context).colorScheme.surface)),
                        );
                      },
                      strokeColor: Color(0xFFfa3d4a),//Colors.white30,
                     /* legend: const MapLegend.bar(MapElement.shape,
                          position: MapLegendPosition.bottom,
                          overflowMode: MapLegendOverflowMode.wrap,
                          labelsPlacement: MapLegendLabelsPlacement.betweenItems,
                          padding: EdgeInsets.only(top: 15),
                          spacing: 1.0,
                          segmentSize: Size(55.0, 9.0)),
                  */
                      tooltipSettings: MapTooltipSettings(
                          color: const Color.fromRGBO(0, 32, 128, 1),
                          strokeColor: Colors.white),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ));
  }
}

class _CountryDensity {
  _CountryDensity(this.countryName, this.density);

  final String countryName;
  final double density;
}