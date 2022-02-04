# typed: strict

class SayWhatYouMeanSimpleAndDirectly
    extend T::Sig

    sig { params(x: Integer, y: Integer, z: Integer).returns(Integer)}
    def self.f(x, y, z)
        if x <= y
            if x <= z
                return x
            end
            return z
        end
        if y <= z
            return y
        end
        z
    end

    sig { params(x: Integer, y: Integer, z: Integer).returns(Integer)}
    def self.smallest(x, y, z)
        smallest = x
        return y if y < smallest
        return z if z < smallest
        smallest
    end
end



