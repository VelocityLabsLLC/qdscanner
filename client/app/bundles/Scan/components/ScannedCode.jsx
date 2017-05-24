import React from 'react';
import {Card, CardActions, CardText, CardHeader} from 'material-ui/Card';
import FlatButton from 'material-ui/FlatButton';
import DeleteIcon from 'material-ui/svg-icons/action/delete';
import EditIcon from 'material-ui/svg-icons/editor/mode-edit';
import AddIcon from 'material-ui/svg-icons/content/add';
import Divider from 'material-ui/Divider';
import PropTypes from 'prop-types';

const pointGenerator = points => i => `(${points[i][0].toFixed(0)}, ${points[i][1].toFixed(0)})`;
const lineGenerator = line => i => `(${line[i].x.toFixed(0)}, ${line[i].y.toFixed(0)})`;

const renderLineSegments = items => (
    <div style={{display: 'flex', flexWrap: 'wrap', justifyContent: 'space-between', flexBasis: '100%'}}>
        {items.map((item, i) => (
            <div key={i} style={{width: `30%`, textAlign: 'center', padding: '0.2rem'}} >{item}</div>
        ))}
    </div>
);

const renderBox = box => {
    const p = pointGenerator(box);
    const items = [p(1), `→`, p(2), `↑`, ' ', `↓`, p(0), `←`, p(3)];
    return renderLineSegments(items);
};

const renderLine = line => {
    const l = lineGenerator(line);
    const items = [l(0), `→`, l(1)];
    return renderLineSegments(items);
};

const renderAngle = angle => (
    <span>
        {(angle * 180 / Math.PI).toFixed(2)}
    </span>
);

const renderDirection = direction => (
    <span>
        {direction === -1 ? 'forward' : `reverse`}
    </span>
);

const keyStyle = {
    fontWeight: 'bold',
    flex: '0 1 70px',
};

const lineStyle = {
    marginBottom: '0.5rem',
    marginTop: '0.5rem',
    display: 'flex',
    alignItems: 'center',
};

const cageExists = scannedCode => {
    if (scannedCode.cageData.id) {
      return scannedCode.cageData.protocol;
    } else {
      return "Cage record not found";
    }
};

const ScannedCode = ({scannedCode, onDelete, onEdit, onAdd}) => {
    return (
        <Card
            style={{margin: '0.5em 0.25em 0em'}}>
          <CardHeader
            textStyle={{paddingRight: '20px', maxWidth: '100%', boxSizing: 'border-box'}}
            titleStyle={{fontSize: '18px', wordWrap: 'break-word'}}
            title={scannedCode.codeResult.code}
            // subtitle={scannedCode.codeResult.format}
            subtitle={cageExists(scannedCode)}
            actAsExpander={true}
            showExpandableButton={true}
          />
          <CardText expandable={true}>
            <div style={lineStyle}>
                <div style={keyStyle}>cageData: </div><div>{scannedCode.cageData.cage_number}</div>
            </div>
            <Divider />
            <div style={lineStyle}>
                <div style={keyStyle}>Direction: </div><div>{renderDirection(scannedCode.codeResult.direction)}</div>
            </div>
            <Divider />
            <div style={lineStyle}>
                <div style={keyStyle}>Angle: </div><div>{renderAngle(scannedCode.angle)} deg</div>
            </div>
            <Divider />
            <div style={lineStyle}>
                <div style={keyStyle}>Line: </div>{renderLine(scannedCode.line)}
            </div>
            <Divider />
            <div style={lineStyle}>
               <div style={keyStyle}>Box: </div>
               {renderBox(scannedCode.box)}
            </div>  
          </CardText>
          
          <CardActions expandable={true}>
            <FlatButton
              label=""
              style={{minWidth: '36px', color: '#aaa'}}
              onClick={onDelete} icon={<DeleteIcon />} />
            <FlatButton
              label=""
              disabled={true}
              style={{minWidth: '36px', color: '#aaa'}}
              onClick={onEdit} icon={<EditIcon />} />
            <FlatButton
              label=""
              disabled={true}
              style={{minWidth: '36px', color: '#aaa'}}
              onClick={onAdd} icon={<AddIcon />} />
          </CardActions>
          
        </Card>
    );
};

ScannedCode.propTypes = {
    scannedCode: PropTypes.object.isRequired,
    onDelete: PropTypes.func,
    onEdit: PropTypes.func,
};

export default ScannedCode;