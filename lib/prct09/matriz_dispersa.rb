require "./lib/prct09/matriz.rb"
require "./lib/prct09/matriz_densa.rb"

module Prct09
  class Matriz_Dispersa < Matriz  
    def reset
      @contenido = Array.new(@N) # Tendra solo filas
      i = 0
      while(i < @N)
        @contenido[i] = {}
        i += 1
      end
    end
    
    def initialize(n, m)
      super
      reset
    end
    
    # Metodo factoria
    def self.copy(matriz)
      raise ArgumentError, 'Tipo invalido' unless matriz.is_a? Prct09::Matriz_Densa
      obj = new(matriz.N, matriz.M)
    
      i = 0
      while(i < matriz.N)
        j = 0
        while(j < matriz.M)
          value = matriz.get(i,j)
          raise RuntimeError , "No se ha definido \"null\" para la clase #{value.class}" unless value.class.respond_to? :null
          
          if( value != value.class.null)
            obj.contenido[i][j] = value
          end 
          j += 1
        end 
        i += 1
      end 
      obj
    end 
    
    def null_percent
      total = @N*@M
      no_nulos = 0
      
      i = 0
      while(i < @N)
        no_nulos += @contenido[i].size 
        i += 1
      end
      
      nulos = total - no_nulos
      nulos.to_f/total.to_f
    end 
    
    def get(i, j)
      if( !(i.is_a? Fixnum) or i < 0 or i >=@N or !(j.is_a? Fixnum) or j < 0 or j >= @M)
        return nil
      end
        
      if(@contenido[i][j] != nil) 
        return @contenido[i][j]
      else # Elemento nulo
        return 0
      end
    end 
    
    def set(i, j, value)
      if(!(value.class.respond_to? :null))
        puts "Se debe definir el metodo \"null\" que devuelva un elemento nulo para la clase #{value.class}"
        return nil
      end
      
      if( !(i.is_a? Fixnum) or i < 0 or i >=@N or !(j.is_a? Fixnum) or j < 0 or j >= @M)
        return nil
      end
      
      if(value == nil or value == value.class.null)
        @contenido[i].delete(j) # Si el valor es nulo lo borramos
      else
        @contenido[i][j] = value
      end
      
    end 
    
    def to_s
      salida = ""
      while(i < @N)
        salida += "Fila #{i}: "
        @contenido[i].sort.each{|k, v| salida += "#{k.to_s}=>#{v.to_s} "}
        salida += "\n"
        i += 1
      end
      salida
    end

    def +(other)
                      raise ArgumentError , 'Tipo invalido' unless other.is_a? Matriz
                      raise ArgumentError , 'Matriz no compatible' unless @N == other.N and @M == other.M
  
                      c = Matriz_Densa.new(@N, @M)
                      i = 0
                      while(i < @N)
                        j = 0
                        while(j < @M)
                                      c.set(i, j, get(i,j) + other.get(i,j))
                                      j += 1
                        end 
                        i += 1
                      end
                      if(c.null_percent > 0.6)
                        c = Matriz_Dispersa.copy(c)
                      end
                      c
    end
        
    def -(other)
                      raise ArgumentError , 'Tipo invalido' unless other.is_a? Matriz
                      raise ArgumentError , 'Matriz no compatible' unless @N == other.N and @M == other.M
  
                      c = Matriz_Densa.new(@N, @M)
                      i = 0
                      while(i < @N)
                        j = 0
                        while(j < @M)
                                      c.set(i, j, get(i,j) - other.get(i,j))
                                      j += 1
                        end
                        i += 1
                      end
                      if(c.null_percent > 0.6)
                        c = Matriz_Dispersa.copy(c)
                      end                
                      c
    end
        
    def *(other)
                    raise ArgumentError , 'Parametro invalido' unless other.is_a? Numeric or other.is_a? Matriz

                    if(other.is_a? Numeric) # Matriz * numero
                              c = Matriz_Densa.new(@N, @M)
                              i = 0
                              while(i < @N)
                                j = 0
                                while(j < @M)
                                         c.set(i, j, get(i,j)*other)
                                         j += 1
                                    end 
                                    i += 1
                              end 
                    else 
                              raise ArgumentError , 'Matriz no compatible (A.N == B.M)' unless @M == other.N
                              c = Matriz_Densa.new(@N, other.M)
                              i = 0
                              while(i < @N)
                                j = 0
                                while(j < other.M)
                                  k = 0
                                        
				  while(k < @M)
						  c.set(i, j, get(i, k) * other.get(k,j) + c.get(i,j))
						  k += 1
				  end 
				j += 1
                               end 
                              i += 1
                              end 
                    end 
                if(c.null_percent > 0.6)
                        c = Matriz_Dispersa.copy(c)
                end  
                    c
    end 
        
    
    #Practica 10
    
        def max
          if(null_percent == 1.0)
            return nil # o return 0
          end
                
         
          max = nil

          i = 0
          while(max == nil)
            if(@contenido[i].size != 0)
                  max = @contenido[i].values[0]
                end
                i += 1
          end

          i = 0
          while(i < @contenido.size)
            if(@contenido[i].values.max != nil and @contenido[i].values.max > max)
                  max = @contenido[i].values.max
                end
            i += 1
          end
          
          max
        end
        
        def min
          if(null_percent == 1.0)
            return nil 
          end

          min = nil
          
     
          i = 0
          while(min == nil)
            if(@contenido[i].size != 0)
                  min = @contenido[i].values[0]
                end
                i += 1
          end

          i = 0
          while(i < @contenido.size)
            if(@contenido[i].values.min != nil and @contenido[i].values.min < min)
                  min = @contenido[i].values.min
                end
            i += 1
          end
          
          min
    end
    
  end 
end 