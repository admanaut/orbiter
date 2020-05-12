import React from 'react';
import { Theme, createStyles, makeStyles } from '@material-ui/core/styles';
import GridList from '@material-ui/core/GridList';
import GridListTile from '@material-ui/core/GridListTile';
import GridListTileBar from '@material-ui/core/GridListTileBar';
import ListSubheader from '@material-ui/core/ListSubheader';
import IconButton from '@material-ui/core/IconButton';
import InfoIcon from '@material-ui/icons/Info';
import Tooltip from '@material-ui/core/Tooltip';
import { APOD, parseAPOD } from '@/model/APOD';
import { APODDialog } from '@/components/APODDialog';

const useStyles = makeStyles((theme: Theme) =>
    createStyles({
        root: {
            display: 'flex',
            flexWrap: 'wrap',
            justifyContent: 'space-around',
            overflow: 'hidden',
            backgroundColor: theme.palette.background.paper,
        },
        gridList: {
            width: 750,
        },
        icon: {
            color: 'rgba(255, 255, 255, 0.54)',
        }
    }),
);

export function App(): JSX.Element {
    const classes = useStyles();
    const [selectedAPOD, setselectedAPOD] = React.useState(null);
    const [apodData, setApodData] = React.useState([]);

    React.useEffect(() => {
        const d = new Date();
        const dt = Array.from(Array(30).keys()).map((_) => {
            d.setDate(d.getDate() - 1);
            return d.toISOString().slice(0, 10);
        });

        function fetchAPOD(date: string): Promise<APOD> {
            return fetch("https://api.nasa.gov/planetary/apod?hd=true&date="+date+"&api_key=DEMO_KEY")
            .then(res => res.text())
            .then(res => parseAPOD(res));
        };

        const promises = dt.map(fetchAPOD);
        Promise.all(promises).then(setApodData);

    }, []);

    const handleClickOpen = (apod: APOD) => {
        setselectedAPOD(apod);
    };

    const handleClose = () => {
        setselectedAPOD(null);
    };

    return (
        <div className={classes.root}>
            <APODDialog apod={selectedAPOD} onClose={handleClose}/>
            <GridList cellHeight={180} className={classes.gridList} cols={3}>
                <GridListTile key="Subheader" cols={3} style={{ height: 'auto' }}>
                    <ListSubheader component="div">APOD</ListSubheader>
                </GridListTile>
                {apodData.map((apod: APOD) => (
                    <GridListTile key={apod.url}>
                        <img src={apod.url} alt={apod.title} />
                        <GridListTileBar
                            title={apod.title}
                            subtitle={<span>{apod.date}</span>}
                            actionIcon={
                                <Tooltip title="See more">
                                    <IconButton aria-label={`info about ${apod.title}`} className={classes.icon} onClick={() => handleClickOpen(apod)}>
                                        <InfoIcon />
                                    </IconButton>
                                </Tooltip>
                            }
                        />
                    </GridListTile>
                ))}
            </GridList>
        </div>
    );
}
