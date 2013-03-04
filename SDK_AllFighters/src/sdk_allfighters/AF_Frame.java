/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package sdk_allfighters;

import development.XStreamer_FImage;
import java.awt.HeadlessException;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.event.*;
import java.io.File;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JFrame;
import modele.objects.Box;
import modele.objects.Box_Type;
import modele.objects.FImage;
import serializer.SerializerImg;

/**
 *
 * @author MyMac
 */
public class AF_Frame extends JFrame {

    private FImage image;
    //
    private AF_MenuBar menuBar;
    private AF_Panel panel;
    //
    private Point p1;
    //
    private boolean enregistrable;
    private String path;
    //
    private String location = "../SpriteAllFighters/TakeshiYamamoto/";
    private int num = 1;
    
    public AF_Frame() throws HeadlessException {
        super("SDK_AllFighters");                
        
        this.setSize(800, 600);
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        this.setLocationRelativeTo(null);        
        
        this.enregistrable = false;
        
        this.addKeyListener(new KeyListener() {

            @Override
            public void keyTyped(KeyEvent ke) {
                //throw new UnsupportedOperationException("Not supported yet.");
            }

            @Override
            public void keyPressed(KeyEvent ke) {
                //throw new UnsupportedOperationException("Not supported yet.");
                if (AF_Frame.this.getImage() != null) {
                    if (ke.getKeyCode() == KeyEvent.VK_RIGHT) {
                        num++;
                        //System.out.println(num);
                        update();
                    } else if (ke.getKeyCode() == KeyEvent.VK_LEFT) {
                        num--;
                        //System.out.println(num);
                        update();
                    }
                }


            }

            @Override
            public void keyReleased(KeyEvent ke) {
                //throw new UnsupportedOperationException("Not supported yet.");
            }
        });
    }
    
    public void update() {
        //SerializerImg si = new SerializerImg();
        FImage image = null;
        //image = (FImage) new XStreamer_FImage().load(location + num);//si.recup(location + num);
        try {
            System.out.println(path);
            
            String extension = path.substring(path.lastIndexOf("."));
            String location = path.substring(0,path.lastIndexOf("/")+1);
            path = location+num+extension;
            
            image = new FImage(0, 0, path);
            this.setImage(image);
        } catch (IOException ex) {
            num = 1;
            update();
            //Logger.getLogger(SDK_AllFighters.class.getName()).log(Level.SEVERE, null, ex);
        }

        //System.out.println(image);
        
    }
    
    public void construire() {
        this.menuBar = new AF_MenuBar(this);
        this.panel = new AF_Panel(this);
        
        this.panel.addMouseListener(new MouseListener() {

            @Override
            public void mouseClicked(MouseEvent me) {
                //System.out.println("MouseClicked : "+me.getPoint());
            }

            @Override
            public void mousePressed(MouseEvent me) {
                //System.out.println("MousePressed : "+me.getPoint());
                AF_Frame.this.p1 = me.getPoint();
            }

            @Override
            public void mouseReleased(MouseEvent me) {
                //System.out.println("MouseReleased : "+me.getPoint());
                Point p2 = me.getPoint();
                
                Rectangle rect = new Rectangle();
                
                p1.x = p1.x/4;
                p1.y = p1.y/4;
                p2.x = p2.x/4;
                p2.y = p2.y/4;
                
                
                if (p1.x < p2.x) {
                    rect.x = p1.x;
                    rect.width = p2.x - p1.x;
                } else {
                    rect.x = p2.x;
                    rect.width = p1.x - p2.x;
                }
                
                if (p1.y < p2.y) {
                    rect.y = p1.y;
                    rect.height = p2.y - p1.y;
                } else {
                    rect.y = p2.y;
                    rect.height = p1.y - p2.y;
                }
                
                System.out.println("image.addBox(new Box(Box_Type.HITTABLE, new Rectangle("+rect.x+","+rect.y+","+rect.width+","+rect.height+")))");
                AF_Frame.this.image.addBox(new Box(Box_Type.HITTABLE, rect));
                AF_Frame.this.panel.repaint();
            }

            @Override
            public void mouseEntered(MouseEvent me) {
                //throw new UnsupportedOperationException("Not supported yet.");
            }

            @Override
            public void mouseExited(MouseEvent me) {
                //throw new UnsupportedOperationException("Not supported yet.");
            }
        });
        this.panel.addMouseMotionListener(new MouseMotionListener() {

            @Override
            public void mouseDragged(MouseEvent me) {
                //System.out.println(me.getPoint());
                //throw new UnsupportedOperationException("Not supported yet.");
            }

            @Override
            public void mouseMoved(MouseEvent me) {
                //System.out.println(me.getPoint());
                //throw new UnsupportedOperationException("Not supported yet.");
            }
        });
        
        this.setJMenuBar(this.menuBar);
        this.add(this.panel);                
    }    
         
    public void setImage(FImage image) {
        this.image = image;
        this.enregistrable = false;
        this.panel.repaint();
    }
    public void setImageI(String path) {
        this.location = path.substring(0, path.lastIndexOf("/")+1);
        
        this.image = (FImage) new XStreamer_FImage().load(path);//si.recup(path);
        this.enregistrable = true;
        this.path = path;
        this.panel.repaint();
    }
    
    public void setImage(File f) {
        try {
            this.image = new FImage(0, 0, f.getAbsolutePath());
            //String path = f.getAbsolutePath().substring(0,f.getAbsolutePath().lastIndexOf("."));
            this.path = f.getAbsolutePath();
            this.location = f.getAbsolutePath().substring(0,f.getAbsolutePath().lastIndexOf("/")+1);
            this.enregistrable = true;
            this.panel.repaint();
        } catch (IOException ex) {
            Logger.getLogger(AF_Frame.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }
    public FImage getImage() {
        return this.image;
    }
    
    public boolean enregistrer() {
        if (this.enregistrable) {
            //SerializerImg.exec(image, path);
            new XStreamer_FImage().save(image, path);
            System.out.println("Modification enregistre");
        }
        
        return this.enregistrable;
    }
}
