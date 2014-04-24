/**************************************************************************
**
**   SNOW - CS224 BROWN UNIVERSITY
**
**   collapsiblebox.cpp
**   Authors: evjang, mliberma, taparson, wyegelwe
**   Created: 23 Apr 2014
**
**************************************************************************/

#include <QApplication>
#include <QLayout>
#include <QMouseEvent>
#include <QPalette>

#include "collapsiblebox.h"

#include "common/common.h"

CollapsibleBox::CollapsibleBox( QWidget *widget )
    : QGroupBox(widget),
      m_clicked(false),
      m_collapsed(false)
{
    this->setAutoFillBackground( true );
}

void
CollapsibleBox::mousePressEvent( QMouseEvent *event )
{
    if ( !childrenRect().contains( event->pos() ) ) {
        QPalette palette = this->palette();
        palette.setColor( QPalette::Window, palette.dark().color() );
        palette.setColor( QPalette::Button, palette.dark().color() );
        setWidgetPalette( this, palette );
        m_clicked = true;
    }
}

void
CollapsibleBox::mouseReleaseEvent(QMouseEvent*)
{
    if ( m_clicked ) {
        for ( int i = 0; i < children().size(); ++i )
            children()[i]->setProperty( "visible", m_collapsed );
        m_collapsed = !m_collapsed;
        if ( m_collapsed ) setMaximumHeight( 1.25*fontMetrics().height() );
        else setMaximumHeight( 16777215 );
        setWidgetPalette( this, QApplication::palette() );
        m_clicked = false;
        updateGeometry();
    }
}

void
CollapsibleBox::setWidgetPalette( QWidget *widget, const QPalette &palette )
{
    widget->setPalette( palette );
    QList<QWidget*> children = widget->findChildren<QWidget*>();
    for ( int i = 0; i < children.size(); ++i ) {
        setWidgetPalette( children[i], palette );
    }
}